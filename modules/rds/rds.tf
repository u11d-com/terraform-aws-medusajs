data "aws_secretsmanager_secret" "main" {
  // workaround https://github.com/hashicorp/terraform-provider-aws/issues/31519
  arn = join("", aws_db_instance.postgres.master_user_secret.*.secret_arn)
}

data "aws_secretsmanager_secret_version" "main" {
  secret_id = data.aws_secretsmanager_secret.main.id
}

resource "aws_db_subnet_group" "main" {
  name_prefix = "${local.prefix}-subnet-group-"
  description = "DB subnet group used by${local.prefix}."

  subnet_ids = var.vpc.private_subnet_ids

  tags = local.tags
}

resource "aws_db_instance" "postgres" {
  identifier                  = local.prefix
  db_name                     = "medusa"
  engine                      = "postgres"
  allocated_storage           = var.allocated_storage
  engine_version              = var.engine_version
  instance_class              = var.instance_class
  manage_master_user_password = true
  username                    = var.username
  publicly_accessible         = false
  vpc_security_group_ids      = [aws_security_group.server.id]
  db_subnet_group_name        = aws_db_subnet_group.main.name
  skip_final_snapshot         = true
  port                        = var.port
  backup_retention_period     = var.backup_settings != null ? var.backup_settings.retention : null
  backup_window               = var.backup_settings != null ? var.backup_settings.window : null
  copy_tags_to_snapshot       = var.backup_settings != null ? var.backup_settings.copy_tags_to_snapshot : null

  tags = local.tags
}
