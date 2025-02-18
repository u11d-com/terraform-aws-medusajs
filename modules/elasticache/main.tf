locals {
  prefix = "${var.context.project}-${var.context.environment}-elasticache"
  tags = merge(
    var.context,
    {
      Component = "Elasticache"
    }
  )
}
