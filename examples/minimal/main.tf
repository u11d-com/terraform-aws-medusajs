terraform {
  required_version = ">= 1.0"
}

locals {
  project     = "medusa-demo"
  environment = "prod"
}

provider "aws" {
  region = "eu-west-1"
  default_tags {
    tags = {
      Project     = local.project
      Environment = local.environment
      Terraform   = true
    }
  }
}

module "minimal" {
  source = "u11d-com/terraform-u11d-medusajs"

  project     = local.project
  environment = local.environment

  ecr_storefront_create = true

  backend_container_image = "ghcr.io/u11d-com/medusa-backend:1.20.10-latest"
  backend_seed_create = true
  backend_seed_run    = true
  backend_extra_environment_variables = {
    "NODE_ENV" : "development"
  }

  storefront_create          = false
  storefront_container_image = "xxx"
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
