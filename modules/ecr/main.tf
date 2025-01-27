locals {
  prefix = "${var.context.project}-${var.context.environment}"
  tags = {
    Component = "ECR"
  }
}
