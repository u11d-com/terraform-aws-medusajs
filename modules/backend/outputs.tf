output "url" {
  value = "https://${aws_cloudfront_distribution.main.domain_name}"
}

output "admin_secret_arn" {
  value = local.create_admin_user ? aws_secretsmanager_secret.admin_secret[0].arn : null
}

