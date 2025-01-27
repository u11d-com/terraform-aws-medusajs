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

variable "username" {
  description = "The username used to authenticate with the PostgreSQL database."
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "The instance type of the RDS instance."
  type        = string
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes."
  type        = number
}

variable "engine_version" {
  description = "The postgres engine version to use. You can provide a prefix of the version such as 8.0 (for 8.0.36)."
  type        = string
}

variable "port" {
  description = "The port on which the DB accepts connections."
  type        = number
}
