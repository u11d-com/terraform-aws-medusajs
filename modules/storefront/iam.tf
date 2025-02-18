locals {
  container_secret_arns = distinct(
    concat(
      [for src in local.container_secrets : src.arn],
      var.container_registry_credentials != null ? [aws_secretsmanager_secret.registry_credentials[0].arn] : []
    )
  )
}

data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "ecs_task_policy" {
  dynamic "statement" {
    for_each = var.ecr_arn != null ? [1] : []

    content {
      actions = [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
      ]
      resources = [var.ecr_arn]
      effect    = "Allow"
    }
  }

  dynamic "statement" {
    for_each = var.ecr_arn != null ? [1] : []

    content {
      actions = [
        "ecr:GetAuthorizationToken",
      ]
      resources = ["*"]
      effect    = "Allow"
    }
  }

  statement {
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogStream"
    ]
    resources = [
      aws_cloudwatch_log_group.main.arn,
      "${aws_cloudwatch_log_group.main.arn}:log-stream:*"
    ]
    effect = "Allow"
  }

  dynamic "statement" {
    for_each = length(local.container_secret_arns) > 0 ? [1] : []

    content {
      actions = [
        "secretsmanager:GetSecretValue"
      ]
      resources = local.container_secret_arns
      effect    = "Allow"
    }
  }
}

resource "aws_iam_role" "main" {
  name_prefix        = "${local.prefix}-ecs-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json

  tags = local.tags
}

resource "aws_iam_policy" "main" {
  name_prefix = "${local.prefix}-ecs-task"
  policy      = data.aws_iam_policy_document.ecs_task_policy.json

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "main" {
  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.main.arn
}
