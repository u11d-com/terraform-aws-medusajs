variable "context" {
  type = object({
    project     = string
    environment = string
  })
  description = "Project context containing project name and environment"
}

variable "name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "retention_count" {
  description = "How many images to keep in repository"
  type        = number
}
