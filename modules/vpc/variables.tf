variable "context" {
  type = object({
    project     = string
    environment = string
    Owner       = string
    ManagedBy   = string
  })
  description = "Project context containing project name and environment"
}

variable "cidr_block" {
  description = "CIDR block used in VPC"
  type        = string
}

variable "az_count" {
  description = "Number of AZs to cover in a given region."
  type        = number
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}
