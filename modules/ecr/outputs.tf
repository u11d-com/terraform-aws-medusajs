output "url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.main.repository_url
}

output "arn" {
  description = "ECR repository ARN"
  value       = aws_ecr_repository.main.arn
}
