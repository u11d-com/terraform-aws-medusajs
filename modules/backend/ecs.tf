locals {
  container_name = "backend"

  container_default_env = merge(
    {
      DATABASE_URL : var.database_url
    },
    {
      S3_URL : aws_s3_bucket.uploads.bucket_regional_domain_name
      S3_BUCKET : aws_s3_bucket.uploads.id
      S3_REGION : aws_s3_bucket.uploads.region
      S3_ACCESS_KEY_ID : aws_iam_access_key.medusa_s3.id
    },
    var.redis_url != null ? { REDIS_URL : var.redis_url } : {},
    var.store_cors != null ? { STORE_CORS : var.store_cors } : {},
    var.admin_cors != null ? { ADMIN_CORS : var.admin_cors } : {},
    var.run_migrations != null ? { MEDUSA_RUN_MIGRATION : tostring(var.run_migrations) } : {},
    local.create_admin_user != null ? { MEDUSA_CREATE_ADMIN_USER : tostring(local.create_admin_user) } : {}
  )
  container_env = merge(local.container_default_env, var.extra_environment_variables)

  container_default_secrets = merge(
    {
      JWT_SECRET : {
        arn = aws_secretsmanager_secret.jwt_secret.arn
        key = "::${aws_secretsmanager_secret_version.jwt_secret.version_id}"
      },
      COOKIE_SECRET : {
        arn = aws_secretsmanager_secret.cookie_secret.arn
        key = "::${aws_secretsmanager_secret_version.cookie_secret.version_id}"
      }
      S3_SECRET_ACCESS_KEY : {
        arn = aws_secretsmanager_secret.s3_user_secret.arn
        key = "::${aws_secretsmanager_secret_version.s3_user_secret.version_id}"
      }
    },
    local.create_admin_user ? {
      MEDUSA_ADMIN_EMAIL : {
        arn = aws_secretsmanager_secret.admin_secret[0].arn
        key = "email::${aws_secretsmanager_secret_version.admin_secret[0].version_id}"
      },
      MEDUSA_ADMIN_PASSWORD : {
        arn = aws_secretsmanager_secret.admin_secret[0].arn
        key = "password::${aws_secretsmanager_secret_version.admin_secret[0].version_id}"
      }
    } : {}
  )
  container_secrets = merge(local.container_default_secrets, var.extra_secrets)

  container_definition = {
    name   = local.container_name
    image  = var.container_image
    cpu    = var.resources.cpu
    memory = var.resources.memory
    portMappings = [
      {
        containerPort = var.container_port
        hostPort      = var.container_port
        protocol      = "tcp"
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-region"        = data.aws_region.current.name,
        "awslogs-group"         = var.logs.group
        "awslogs-stream-prefix" = var.logs.prefix
      }
    }
    environment = [for name, value in local.container_env : {
      name  = name
      value = value
    }]
    secrets = [for name, src in local.container_secrets : {
      name      = name
      valueFrom = "${src.arn}:${src.key}"
    }],
    repositoryCredentials = var.container_registry_credentials != null ? {
      credentialsParameter = aws_secretsmanager_secret.registry_credentials[0].arn
    } : null
  }
}

resource "aws_ecs_cluster" "main" {
  name = local.prefix

  tags = local.tags
}

resource "aws_ecs_task_definition" "main" {
  family                   = local.prefix
  execution_role_arn       = aws_iam_role.ecs_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.resources.cpu
  memory                   = var.resources.memory
  container_definitions    = jsonencode([local.container_definition])

  depends_on = [
    aws_iam_role_policy_attachment.ecs_execution,
    aws_iam_role_policy_attachment.ecs_task
  ]

  tags = local.tags
}

resource "aws_ecs_service" "main" {
  name                   = local.prefix
  cluster                = aws_ecs_cluster.main.id
  task_definition        = aws_ecs_task_definition.main.arn
  desired_count          = var.resources.instances
  enable_execute_command = true
  launch_type            = "FARGATE"
  network_configuration {
    security_groups = concat([aws_security_group.ecs.id], var.extra_security_group_ids)
    subnets         = var.vpc.private_subnet_ids
  }
  load_balancer {
    container_name   = local.container_name
    target_group_arn = aws_alb_target_group.main.arn
    container_port   = var.container_port
  }

  wait_for_steady_state = true

  tags = local.tags
}
