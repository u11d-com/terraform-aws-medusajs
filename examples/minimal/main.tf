terraform {
  required_version = "~> 1.9"
}

locals {
  project     = "medusa"
  environment = "prod"
  owner       = "my-team"
}

provider "aws" {
  region = "eu-west-1"
}

module "minimal" {
  source = "../.."

  project     = local.project
  environment = local.environment
  owner       = local.owner

  ecr_storefront_create = true

  backend_container_image = "ghcr.io/u11d-com/medusa-backend:2-3e0612e"
  backend_seed_create     = true
  backend_seed_run        = true
  backend_seed_command    = "yarn seed"
  backend_extra_environment_variables = {
    "NODE_ENV" : "production",
    "MEDUSA_CREATE_ADMIN_USER" : true,
    "MEDUSA_ADMIN_EMAIL" : "admin@medusa-test.com",
    "MEDUSA_ADMIN_PASSWORD" : "supersecret",
  }

  storefront_create = false
}

output "ecr_backend_url" {
  description = "The URL of the backend ECR repository. Only available when ecr_backend_create is true."
  value       = module.minimal.ecr_backend_url
}

output "ecr_storefront_url" {
  description = "The URL of the storefront ECR repository. Only available when ecr_storefront_create is true."
  value       = module.minimal.ecr_storefront_url
}

output "backend_url" {
  description = "The URL of the backend application. Only available when backend_create is true."
  value       = module.minimal.backend_url
}

output "storefront_url" {
  description = "The URL of the storefront application. Only available when storefront_create is true."
  value       = module.minimal.storefront_url
}
