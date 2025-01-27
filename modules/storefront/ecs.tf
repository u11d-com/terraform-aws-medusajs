locals {
  container_name = "storefront"

  container_default_env = {
    MEDUSA_BACKEND_URL : var.backend_url
  }
  container_env = merge(local.container_default_env, var.extra_environment_variables)

  container_default_secrets = {}
  container_secrets         = merge(local.container_default_secrets, var.extra_secrets)

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
  execution_role_arn       = aws_iam_role.main.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.resources.cpu
  memory                   = var.resources.memory
  container_definitions    = jsonencode([local.container_definition])

  depends_on = [
    aws_iam_role_policy_attachment.main
  ]

  tags = local.tags
}

resource "aws_ecs_service" "main" {
  name            = local.prefix
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = var.resources.instances
  launch_type     = "FARGATE"
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
