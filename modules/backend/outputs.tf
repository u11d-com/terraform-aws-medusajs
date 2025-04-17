output "url" {
  value = "https://${aws_cloudfront_distribution.main.domain_name}"
}

output "admin_secret_arn" {
  value = local.create_admin_user ? aws_secretsmanager_secret.admin_secret[0].arn : null
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.main.arn
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.main.name
}
