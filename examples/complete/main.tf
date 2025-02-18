terraform {
  required_version = "~> 1.9"
}

locals {
  project     = "medusa-demo"
  environment = "prod"
  owner       = "my-team"
}

provider "aws" {
  region = "eu-west-1"
}

module "complete" {
  source = "u11d-com/medusajs/aws"

  # Global
  project     = local.project
  environment = local.environment
  owner       = local.owner

  # ECR
  ecr_backend_create             = true
  ecr_backend_retention_count    = 32
  ecr_storefront_create          = true
  ecr_storefront_retention_count = 32

  # Network
  vpc_create = true
  cidr_block = "10.0.0.0/16"
  az_count   = 2

  # Redis (Elasticache)
  elasticache_create               = true
  elasticache_node_type            = "cache.t3.micro"
  elasticache_nodes_num            = 1
  elasticache_redis_engine_version = "7.1"
  elasticache_port                 = 6379

  # Database (RDS)
  rds_create            = true
  rds_username          = "medusa"
  rds_instance_class    = "db.t3.micro"
  rds_allocated_storage = 5
  rds_engine_version    = "15.7"
  rds_port              = 5432

  # Backend
  backend_create         = true
  backend_container_port = 9000
  backend_target_group_health_check_config = {
    interval            = 30
    matcher             = 200
    timeout             = 3
    path                = "/health"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
  backend_cloudfront_price_class = "PriceClass_100"
  backend_expose_admin_only      = false
  backend_container_image        = "your-backend-image:latest"
  backend_resources = {
    instances = 1
    cpu       = 2048
    memory    = 4096
  }
  backend_logs = {
    group     = "/medusa-backend"
    retention = 30
    prefix    = "container"
  }
  backend_run_migrations           = true
  backend_seed_create              = true
  backend_seed_run                 = true
  backend_seed_command             = "npx medusa seed -f ./data/seed.json"
  backend_seed_timeout             = 60
  backend_seed_fail_on_error       = true
  backend_extra_security_group_ids = []
  backend_extra_environment_variables = {
    "NODE_ENV" = "development"
  }
  backend_extra_secrets = {}

  # Storefront
  storefront_create         = true
  storefront_container_port = 8000
  storefront_target_group_health_check_config = {
    interval            = 30
    matcher             = 200
    timeout             = 3
    path                = "/api"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
  storefront_cloudfront_price_class = "PriceClass_100"
  storefront_container_image        = "your-storefront-image:latest"
  storefront_resources = {
    instances = 1
    cpu       = 1024
    memory    = 2048
  }
  storefront_logs = {
    group     = "/medusa-storefront"
    retention = 30
    prefix    = "container"
  }
  storefront_extra_security_group_ids    = []
  storefront_extra_environment_variables = {}
  storefront_extra_secrets               = {}
}

output "ecr_backend_url" {
  description = "The URL of the backend ECR repository. Only available when ecr_backend_create is true."
  value       = module.complete.ecr_backend_url
}

output "ecr_storefront_url" {
  description = "The URL of the storefront ECR repository. Only available when ecr_storefront_create is true."
  value       = module.complete.ecr_storefront_url
}

output "backend_url" {
  description = "The URL of the backend application. Only available when backend_create is true."
  value       = module.complete.backend_url
}

output "storefront_url" {
  description = "The URL of the storefront application. Only available when storefront_create is true."
  value       = module.complete.storefront_url
}
