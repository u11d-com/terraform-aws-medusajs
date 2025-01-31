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

module "external_resources" {
  source = "u11d-com/terraform-u11d-medusajs"

  # Global
  project     = local.project
  environment = local.environment

  # Network - using existing VPC
  vpc_create         = false
  vpc_id             = "vpc-1234567890abcdef0"
  public_subnet_ids  = ["subnet-1234567890abcdef0", "subnet-abcdef1234567890"]
  private_subnet_ids = ["subnet-0987654321fedcba", "subnet-fedcba0987654321"]

  # ECR - using external container registries
  ecr_backend_create    = false
  ecr_storefront_create = false

  # Backend configuration with external container registry
  backend_create          = true
  backend_container_image = "ghcr.io/your-org/backend:tag"
  backend_container_registry_credentials = {
    username = "your-registry-username"
    password = "your-registry-password"
  }

  # Storefront configuration with external container registry
  storefront_create          = true
  storefront_container_image = "ghcr.io/your-org/storefront:tag"
  storefront_container_registry_credentials = {
    username = "your-registry-username"
    password = "your-registry-password"
  }

  # Other resources using default values
  elasticache_create = true
  rds_create         = true
}

output "ecr_backend_url" {
  description = "The URL of the backend ECR repository. Only available when ecr_backend_create is true."
  value       = module.external_resources.ecr_backend_url
}

output "ecr_storefront_url" {
  description = "The URL of the storefront ECR repository. Only available when ecr_storefront_create is true."
  value       = module.external_resources.ecr_storefront_url
}

output "backend_url" {
  description = "The URL of the backend application. Only available when backend_create is true."
  value       = module.external_resources.backend_url
}

output "storefront_url" {
  description = "The URL of the storefront application. Only available when storefront_create is true."
  value       = module.external_resources.storefront_url
}
