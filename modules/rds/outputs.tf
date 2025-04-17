locals {
  db_name  = var.db_create ? aws_db_instance.postgres.db_name : var.db_name
  username = urlencode(jsondecode(data.aws_secretsmanager_secret_version.main.secret_string)["username"])
  password = urlencode(jsondecode(data.aws_secretsmanager_secret_version.main.secret_string)["password"])
}

output "url" {
  value     = "postgres://${var.username}:${local.password}@${aws_db_instance.postgres.address}:${aws_db_instance.postgres.port}/${local.db_name}?sslmode=no-verify"
  sensitive = true
}

output "host" {
  value = aws_db_instance.postgres.address
}

output "port" {
  value = aws_db_instance.postgres.port
}

output "db_name" {
  value = local.db_name
}

output "username" {
  value = local.username
}

output "password_secret_arn" {
  value = data.aws_secretsmanager_secret.main.arn
}

output "client_security_group_id" {
  value = aws_security_group.client.id
}

output "identifier" {
  value = aws_db_instance.postgres.identifier
}
