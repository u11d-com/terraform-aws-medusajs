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

variable "node_type" {
  description = "The Elasticache instance class used."
  type        = string
}

variable "nodes_num" {
  description = "The initial number of cache nodes that the cache cluster will have."
  type        = number
}

variable "redis_engine_version" {
  description = "The version of the redis that will be used to create the Elasticache cluster. You can provide a prefix of the version such as 7.1 (for 7.1.4)."
  type        = string
}

variable "port" {
  description = "Port exposed by the redis to redirect traffic to."
  type        = number
}
