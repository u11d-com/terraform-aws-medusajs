locals {
  prefix = "${var.context.project}-${var.context.environment}"
  tags = merge(
    var.context,
    {
      Component = "ECR"
    }
  )
}
