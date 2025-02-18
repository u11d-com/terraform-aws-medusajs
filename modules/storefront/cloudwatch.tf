resource "aws_cloudwatch_log_group" "main" {
  name_prefix       = "${local.prefix}-${var.logs.group}-"
  retention_in_days = var.logs.retention

  tags = local.tags
}
