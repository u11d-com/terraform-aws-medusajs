# Global

variable "project" {
  description = "The name of the project for which infrastructure is being provisioned."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project))
    error_message = "Project name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "environment" {
  description = "The name of the environment for which infrastructure is being provisioned."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.environment))
    error_message = "Environment name must contain only lowercase letters, numbers, and hyphens."
  }

  validation {
    condition     = length(format("%s-%s", var.project, var.environment)) <= 10
    error_message = "The combined length of project and environment names (including hyphen) must not exceed 10 characters."
  }
}

variable "owner" {
  description = "The owner of the infrastructure resources."
  type        = string
}

# ECR

variable "ecr_backend_create" {
  description = "Enable backend ECR repository creation"
  type        = bool
  default     = false
}

variable "ecr_backend_retention_count" {
  description = "How many images to keep in backend repository"
  type        = number
  default     = 32
}

variable "ecr_storefront_create" {
  description = "Enable storefront ECR repository creation"
  type        = bool
  default     = false
}

variable "ecr_storefront_retention_count" {
  description = "How many images to keep in storefront repository"
  type        = number
  default     = 32
}

# Network

variable "vpc_create" {
  description = "Enable vpc creation"
  type        = bool
  default     = true
}

## VPC instance configuration (when vpc_create = true)

variable "cidr_block" {
  description = "CIDR block used in VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region."
  type        = number
  default     = 2
}

## External VPC configuration (when vpc_create = false)

variable "vpc_id" {
  description = "Existing VPC ID. Required if vpc_create is false."
  type        = string
  default     = null

  validation {
    condition     = var.vpc_create == true || (var.vpc_create != true && var.vpc_id != null)
    error_message = "VPC ID is required when vpc_create is set to false."
  }
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs. Required if vpc_create is false."
  type        = list(string)
  default     = null

  validation {
    condition     = var.vpc_create == true || (var.vpc_create != true && var.public_subnet_ids != null)
    error_message = "Public subnet IDs are required when vpc_create is set to false."
  }
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs. Required if vpc_create is false."
  type        = list(string)
  default     = null

  validation {
    condition     = var.vpc_create == true || (var.vpc_create != true && var.private_subnet_ids != null)
    error_message = "Private subnet IDs are required when vpc_create is set to false."
  }
}

# Redis

variable "elasticache_create" {
  type    = bool
  default = true
}

## Elasticache instance configuration (when elasticache_create = true)

variable "elasticache_node_type" {
  description = "The Elasticache instance class used."
  type        = string
  default     = "cache.t3.micro"
}

variable "elasticache_nodes_num" {
  description = "The initial number of cache nodes that the cache cluster will have."
  type        = number
  default     = 1
}

variable "elasticache_redis_engine_version" {
  description = "The version of the redis that will be used to create the Elasticache cluster. You can provide a prefix of the version such as 7.1 (for 7.1.4)."
  type        = string
  default     = "7.1"
}

variable "elasticache_port" {
  description = "Port exposed by the redis to redirect traffic to."
  type        = number
  default     = 6379
}

## External Redis configuration (when elasticache_create = false)

variable "redis_url" {
  description = "Redis connection URL. Required if elasticache_create is false."
  type        = string
  default     = null
  sensitive   = true

  validation {
    condition     = var.elasticache_create == true || (var.elasticache_create != true && var.redis_url != null)
    error_message = "Redis connection URL is required when elasticache_create is set to false."
  }
}

# Database

variable "rds_create" {
  type    = bool
  default = true
}

## RDS instance configuration (when rds_create = true)

variable "rds_username" {
  description = "The username used to authenticate with the PostgreSQL database."
  type        = string
  sensitive   = true
  default     = "medusa"
}

variable "rds_instance_class" {
  description = "The instance type of the RDS instance."
  type        = string
  default     = "db.t3.micro"
}

variable "rds_allocated_storage" {
  description = "The allocated storage in gigabytes."
  type        = number
  default     = 5
}

variable "rds_engine_version" {
  description = "The postgres engine version to use. You can provide a prefix of the version such as 8.0 (for 8.0.36)."
  type        = string
  default     = "15.7"
}

variable "rds_port" {
  description = "Port exposed by the RDS."
  type        = number
  default     = 5432
}

## External database configuration (when rds_create = false)

variable "database_url" {
  description = "Database connection URL. Required if rds_create is false."
  type        = string
  default     = null
  sensitive   = true

  validation {
    condition     = var.rds_create == true || (var.rds_create != true && var.database_url != null)
    error_message = "Database connection URL is required when rds_create is set to false."
  }
}

# Backend

variable "backend_create" {
  description = "Enable backend resources creation"
  type        = bool
  default     = true
}

## Backend instance configuration (when backend_create = true)

variable "backend_container_port" {
  description = "Port exposed by the task container to redirect traffic to."
  type        = number
  default     = 9000
}

variable "backend_target_group_health_check_config" {
  description = "Health check configuration for load balancer target group pointing on backend containers"
  type = object({
    interval            = number
    matcher             = number
    timeout             = number
    path                = string
    healthy_threshold   = number
    unhealthy_threshold = number
  })
  default = {
    interval            = 30
    matcher             = 200
    timeout             = 3
    path                = "/health"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

variable "backend_cloudfront_price_class" {
  description = "The price class for the backend CloudFront distribution"
  type        = string
  default     = "PriceClass_100"
}

variable "backend_expose_admin_only" {
  description = "Whether to expose publicly only /admin paths in the backend"
  type        = bool
  default     = false
}

variable "backend_ecr_arn" {
  description = "ARN of Elastic Container Registry. Cannot be used together with backend_container_registry_credentials."
  type        = string
  default     = null

  validation {
    condition     = var.backend_ecr_arn != true || var.ecr_backend_create != true
    error_message = "Only one of backend_ecr_arn or ecr_backend_create can be enabled."
  }
}

variable "backend_container_registry_credentials" {
  description = "Credentials for private container registry authentication. Cannot be used together with backend_ecr_arn."
  type = object({
    username = string
    password = string
  })
  default = null

  validation {
    condition     = var.backend_container_registry_credentials != true || var.ecr_backend_create != true
    error_message = "Only one of backend_container_registry_credentials or ecr_backend_create can be enabled."
  }

  validation {
    condition     = var.backend_container_registry_credentials != true || var.backend_ecr_arn != true
    error_message = "Only one of backend_container_registry_credentials or backend_ecr_arn can be enabled."
  }
}

variable "backend_container_image" {
  description = "Image tag of the docker image to run in the ECS cluster."
  type        = string
  default     = "ghcr.io/u11d-com/medusa-backend:1.20.10-latest"
}

variable "backend_resources" {
  description = "ECS Task configuration settings"
  type = object({
    instances = number
    cpu       = number
    memory    = number
  })
  default = {
    instances = 1
    cpu       = 2048
    memory    = 4096
  }
}

variable "backend_logs" {
  description = "Logs configuration settings"
  type = object({
    group     = string
    retention = number
    prefix    = string
  })
  default = {
    group     = "/medusa-backend"
    retention = 30
    prefix    = "container"
  }
}

variable "backend_jwt_secret" {
  description = "Secret used for JWT token signing. If not provided, a random secret will be generated."
  type        = string
  sensitive   = true
  default     = null
}

variable "backend_cookie_secret" {
  description = "Secret used for cookie signing. If not provided, a random secret will be generated."
  type        = string
  sensitive   = true
  default     = null
}

variable "backend_store_cors" {
  description = "CORS configuration for the store. If not provided, CORS will not be configured."
  type        = string
  default     = null
}

variable "backend_admin_cors" {
  description = "CORS configuration for the admin panel. If not provided, CORS will not be configured."
  type        = string
  default     = null
}

variable "backend_run_migrations" {
  description = "Specify backend migrations should be run on start."
  type        = bool
  default     = true
}

variable "backend_seed_create" {
  description = "Enable backend seed function creation"
  type        = bool
  default     = false
}

variable "backend_seed_run" {
  description = "Specify backend seed should be run after deployment."
  type        = bool
  default     = false
}

variable "backend_seed_command" {
  description = "Command to run to seed the database."
  type        = string
  default     = "npx medusa seed -f ./data/seed.json"
}

variable "backend_seed_timeout" {
  description = "Timeout for the seed command (seconds)."
  type        = number
  default     = 120
}

variable "backend_seed_fail_on_error" {
  description = "Whether to fail the deployment if the seed command fails."
  type        = bool
  default     = true
}

variable "backend_admin_credentials" {
  description = "Admin user credentials. If provided, it will be used to create an admin user."
  type = object({
    email             = string
    password          = optional(string)
    generate_password = optional(bool, true)
  })
  default   = null
  sensitive = true

  validation {
    condition = (
      var.backend_create != true ||
      (var.backend_admin_credentials != null ? var.backend_admin_credentials.email != null : true)
    )
    error_message = "Admin email is required when backend_create is true and admin credentials are provided"
  }

  validation {
    condition = (
      var.backend_create != true ||
      (var.backend_admin_credentials != null ? var.backend_admin_credentials.generate_password == true : true) ||
      (var.backend_admin_credentials != null ? var.backend_admin_credentials.password != null : true)
    )
    error_message = "Admin password is required when backend_create is true, admin credentials are provided and generate_password is false"
  }
}

variable "backend_extra_security_group_ids" {
  description = "List of additional security group IDs to associate with the backend ECS service"
  type        = list(string)
  default     = []
}

variable "backend_extra_environment_variables" {
  description = "Additional environment variables to pass to the backend container"
  type        = map(string)
  default     = {}
}

variable "backend_extra_secrets" {
  description = "Additional secrets to pass to the backend container"
  type = map(object({
    arn = string
    key = string
  }))
  default = {}
}

## External backend configuration (when backend_create = false)

variable "backend_url" {
  description = "Medusa backend URL. Required if backend_create is false."
  type        = string
  default     = null

  validation {
    condition     = var.backend_create == true || (var.backend_create != true && var.backend_url != null)
    error_message = "Backend URL is required when backend_create is set to false."
  }
}

# Storefront

variable "storefront_create" {
  description = "Enable storefront resources creation"
  type        = bool
  default     = false
}

## Storefront instance configuration (when storefront_create = true)

variable "storefront_container_port" {
  description = "Port exposed by the task container to redirect traffic to."
  type        = number
  default     = 8000
}

variable "storefront_target_group_health_check_config" {
  description = "Health check configuration for load balancer target group pointing on storefront containers"
  type = object({
    interval            = number
    matcher             = number
    timeout             = number
    path                = string
    healthy_threshold   = number
    unhealthy_threshold = number
  })
  default = {
    interval            = 30
    matcher             = 200
    timeout             = 3
    path                = "/api"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

variable "storefront_cloudfront_price_class" {
  description = "The price class for the CloudFront distribution"
  type        = string
  default     = "PriceClass_100"
}

variable "storefront_ecr_arn" {
  description = "ARN of Elastic Container Registry. Cannot be used together with storefront_container_registry_credentials."
  type        = string
  default     = null

  validation {
    condition     = var.storefront_container_registry_credentials == null || var.storefront_ecr_arn == null
    error_message = "Only one of storefront_ecr_arn or storefront_container_registry_credentials can be specified."
  }
}

variable "storefront_container_registry_credentials" {
  description = "Credentials for private container registry authentication. Cannot be used together with storefront_ecr_arn."
  type = object({
    username = string
    password = string
  })
  default = null
}

variable "storefront_container_image" {
  description = "Image tag of the docker image to run in the ECS cluster."
  type        = string
  default     = null
}

variable "storefront_resources" {
  description = "ECS Task configuration settings"
  type = object({
    instances = number
    cpu       = number
    memory    = number
  })
  default = {
    instances = 1
    cpu       = 1024
    memory    = 2048
  }
}

variable "storefront_logs" {
  description = "Logs configuration settings"
  type = object({
    group     = string
    retention = number
    prefix    = string
  })
  default = {
    group     = "/medusa-storefront"
    retention = 30
    prefix    = "container"
  }
}

variable "storefront_extra_security_group_ids" {
  description = "List of additional security group IDs to associate with the storefront ECS service"
  type        = list(string)
  default     = []
}

variable "storefront_extra_environment_variables" {
  description = "Additional environment variables to pass to the storefront container"
  type        = map(string)
  default     = {}
}

variable "storefront_extra_secrets" {
  description = "Additional secrets to pass to the storefront container"
  type = map(object({
    arn = string
    key = string
  }))
  default = {}
}

