locals {
  lambda_seed_function_name = "${local.prefix}-seed"
  lambda_seed_dir           = "${path.module}/lambda/seed"
  lambda_seed_source_hash = sha256(
    join("\n", [
      for fn in fileset(".", "${local.lambda_seed_dir}/**") : file(fn)
    ])
  )
  lambda_seed_archive_file = "${path.module}/lambda/seed.zip"
}

resource "null_resource" "lambda_seed_source_hash_changed" {
  triggers = {
    "hash" = local.lambda_seed_source_hash
  }
}

resource "archive_file" "seed" {
  count = var.seed_create ? 1 : 0

  type        = "zip"
  source_dir  = local.lambda_seed_dir
  output_path = local.lambda_seed_archive_file

  lifecycle {
    replace_triggered_by = [null_resource.lambda_seed_source_hash_changed]
  }
}

resource "aws_lambda_function" "seed" {
  count = var.seed_create ? 1 : 0

  filename         = local.lambda_seed_archive_file
  source_code_hash = local.lambda_seed_source_hash
  function_name    = local.lambda_seed_function_name
  role             = aws_iam_role.lambda_seed[0].arn
  handler          = "index.handler"
  runtime          = "nodejs22.x"
  timeout          = var.seed_timeout * 2 // Make it long enough for command to finish first

  environment {
    variables = {
      CLUSTER_NAME   = aws_ecs_cluster.main.name
      SERVICE_NAME   = aws_ecs_service.main.name
      CONTAINER_NAME = local.container_name
      COMMAND        = var.seed_command
      TIMEOUT        = var.seed_timeout
      FAIL_ON_ERROR  = var.seed_fail_on_error
    }
  }

  depends_on = [archive_file.seed]

  tags = local.tags
}

resource "aws_lambda_invocation" "seed" {
  count = var.seed_create && var.seed_run ? 1 : 0

  function_name = aws_lambda_function.seed[0].function_name
  input         = jsonencode({})

  triggers = {
    source_code_hash = aws_lambda_function.seed[0].source_code_hash
    function_arn     = aws_lambda_function.seed[0].arn
    environment      = jsonencode(aws_lambda_function.seed[0].environment)
  }

  depends_on = [aws_lambda_function.seed, aws_ecs_service.main]
}
