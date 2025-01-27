resource "aws_secretsmanager_secret" "registry_credentials" {
  count = var.container_registry_credentials != null ? 1 : 0

  name_prefix = "${local.prefix}-registry-"
  description = "Backend container registry credentials"

  tags = local.tags
}

resource "aws_secretsmanager_secret_version" "registry_credentials" {
  count = var.container_registry_credentials != null ? 1 : 0

  secret_id = aws_secretsmanager_secret.registry_credentials[0].id
  secret_string = jsonencode({
    username = var.container_registry_credentials.username
    password = var.container_registry_credentials.password
  })
}
