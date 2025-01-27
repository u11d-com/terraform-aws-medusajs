locals {
  prefix = "${var.context.project}-${var.context.environment}-elasticache"
  tags = {
    Component = "Elasticache"
  }
}
