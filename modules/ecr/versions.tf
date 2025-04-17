terraform {
  required_version = "~> 1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.94.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.3"
    }
  }
}
