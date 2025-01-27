variable "context" {
  type = object({
    project     = string
    environment = string
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
