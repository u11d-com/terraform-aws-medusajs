locals {
  create_admin_user = var.admin_credentials != null
  admin_password = local.create_admin_user ? (
    var.admin_credentials.generate_password ?
    random_password.admin_password[0].result : var.admin_credentials.password
  ) : null
  jwt_secret    = var.jwt_secret != null ? var.jwt_secret : random_password.jwt_secret[0].result
  cookie_secret = var.cookie_secret != null ? var.cookie_secret : random_password.cookie_secret[0].result
}

resource "random_password" "admin_password" {
  count = local.create_admin_user ? (var.admin_credentials.generate_password ? 1 : 0) : 0

  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "admin_secret" {
  count = local.create_admin_user ? 1 : 0

  name_prefix = "${local.prefix}-admin-"
  description = "Backend admin credentials"

  tags = local.tags
}

resource "aws_secretsmanager_secret_version" "admin_secret" {
  count = local.create_admin_user ? 1 : 0

  secret_id = aws_secretsmanager_secret.admin_secret[0].id
  secret_string = jsonencode({
    email    = var.admin_credentials.email
    password = local.admin_password
  })
}

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

resource "random_password" "jwt_secret" {
  count = var.jwt_secret == null ? 1 : 0

  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "jwt_secret" {
  name_prefix = "${local.prefix}-jwt-"
  description = "JWT signing secret"

  tags = local.tags
}

resource "aws_secretsmanager_secret_version" "jwt_secret" {
  secret_id     = aws_secretsmanager_secret.jwt_secret.id
  secret_string = local.jwt_secret
}

resource "random_password" "cookie_secret" {
  count = var.cookie_secret == null ? 1 : 0

  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "cookie_secret" {
  name_prefix = "${local.prefix}-cookie-"
  description = "Cookie signing secret"

  tags = local.tags
}

resource "aws_secretsmanager_secret_version" "cookie_secret" {
  secret_id     = aws_secretsmanager_secret.cookie_secret.id
  secret_string = local.cookie_secret
}

resource "aws_secretsmanager_secret" "s3_user_secret" {
  name_prefix = "${local.prefix}-s3-user-"
  description = "Secret access key for S3 user"

  tags = local.tags
}

resource "aws_secretsmanager_secret_version" "s3_user_secret" {
  secret_id     = aws_secretsmanager_secret.s3_user_secret.id
  secret_string = aws_iam_access_key.medusa_s3.secret
}
