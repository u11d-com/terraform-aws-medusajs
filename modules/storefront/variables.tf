variable "context" {
  type = object({
    project     = string
    environment = string
  })
  description = "Project context containing project name and environment"
}

variable "vpc" {
  type = object({
    id                 = string
    public_subnet_ids  = list(string)
    private_subnet_ids = list(string)
  })
  description = "VPC configuration object containing VPC ID and subnet IDs"
}

variable "container_port" {
  description = "Port exposed by the task container to redirect traffic to."
  type        = number
}

variable "target_group_health_check_config" {
  description = "Health check configuration for load balancer target group pointing on backend containers"
  type = object({
    interval            = number
    matcher             = number
    timeout             = number
    path                = string
    healthy_threshold   = number
    unhealthy_threshold = number
  })
}

variable "cloudfront_price_class" {
  description = "The price class for the CloudFront distribution"
  type        = string
}

variable "ecr_arn" {
  description = "ARN of Elastic Container Registry."
  type        = string
}

variable "container_registry_credentials" {
  description = "Credentials for private container registry authentication"
  type = object({
    username = string
    password = string
  })
}

variable "container_image" {
  type = string
}

variable "resources" {
  description = "ECS Task configuration settings"
  type = object({
    instances = number
    cpu       = number
    memory    = number
  })
}

variable "logs" {
  description = "Logs configuration settings"
  type = object({
    group     = string
    retention = number
    prefix    = string
  })
}

variable "extra_security_group_ids" {
  description = "List of additional security group IDs to associate with the ECS service"
  type        = list(string)
}

variable "extra_environment_variables" {
  description = "Additional environment variables to pass to the container"
  type        = map(string)
}

variable "extra_secrets" {
  description = "Additional secrets to pass to the container"
  type = map(object({
    arn = string
    key = string
  }))
}

variable "backend_url" {
  description = "URL for backend connection"
  type        = string
}
