data "aws_region" "current" {}

locals {
  prefix = "${var.context.project}-${var.context.environment}-storefront"
  tags = merge(
    var.context,
    {
      Component = "Storefront"
    }
  )
}
