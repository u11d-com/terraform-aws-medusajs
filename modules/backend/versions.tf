terraform {
  required_version = "~> 1.10.0"

  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.7.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.84.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.3"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.3"
    }
  }
}
