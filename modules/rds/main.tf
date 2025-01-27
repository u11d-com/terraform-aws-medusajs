locals {
  prefix = "${var.context.project}-${var.context.environment}-rds"
  tags = {
    Component = "RDS"
  }
}
