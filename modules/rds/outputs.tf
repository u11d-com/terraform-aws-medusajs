locals {
  password = urlencode(jsondecode(data.aws_secretsmanager_secret_version.main.secret_string)["password"])
}

output "url" {
  value     = "postgres://${var.username}:${local.password}@${aws_db_instance.postgres.address}:${aws_db_instance.postgres.port}/${aws_db_instance.postgres.db_name}?sslmode=no-verify"
  sensitive = true
}

output "client_security_group_id" {
  value = aws_security_group.client.id
}
