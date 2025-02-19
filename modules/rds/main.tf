locals {
  prefix = "${var.context.project}-${var.context.environment}-rds"
  tags = merge(
    var.context,
    {
      Component = "RDS"
    }
  )
}
