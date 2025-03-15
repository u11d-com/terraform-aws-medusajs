variable "context" {
  type = object({
    project     = string
    environment = string
    Owner       = string
    ManagedBy   = string
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

variable "backup_settings" {
  description = "Backup settings for the RDS instance."
  type = object({
    window                = string
    retention             = number
    copy_tags_to_snapshot = bool
  })
  default = null
}

variable "db_create" {
  description = "Whether to create the database."
  type        = bool
  default     = true
}

variable "db_name" {
  description = "The name of the database to create. If db_create is false, this is the name of the existing database."
  type        = string
  default     = "medusa"
}

variable "maintenance_window" {
  description = "The weekly time range during which system maintenance can occur, in UTC."
  type        = string
  default     = null
}
