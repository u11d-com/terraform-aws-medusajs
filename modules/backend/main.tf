data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  prefix = "${var.context.project}-${var.context.environment}-backend"
  tags = {
    Component = "Backend"
  }
}
