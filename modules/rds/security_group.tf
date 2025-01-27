resource "aws_security_group" "server" {
  name_prefix = "${local.prefix}-server-"
  description = "Allow communication RDS to communicate with other services."

  vpc_id = var.vpc.id

  tags = local.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "server" {
  security_group_id = aws_security_group.server.id

  referenced_security_group_id = aws_security_group.client.id
  from_port                    = aws_db_instance.postgres.port
  to_port                      = aws_db_instance.postgres.port
  ip_protocol                  = "tcp"

  tags = local.tags
}

resource "aws_vpc_security_group_egress_rule" "server" {
  security_group_id = aws_security_group.server.id

  referenced_security_group_id = aws_security_group.client.id
  ip_protocol                  = "-1"

  tags = local.tags
}

resource "aws_security_group" "client" {
  name_prefix = "${local.prefix}-client-"
  description = "Allow clients to communicate with RDS."

  vpc_id = var.vpc.id

  tags = local.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "client" {
  security_group_id = aws_security_group.client.id

  referenced_security_group_id = aws_security_group.server.id
  ip_protocol                  = "-1"

  tags = local.tags
}

resource "aws_vpc_security_group_egress_rule" "client" {
  security_group_id = aws_security_group.client.id

  referenced_security_group_id = aws_security_group.server.id
  from_port                    = aws_db_instance.postgres.port
  to_port                      = aws_db_instance.postgres.port
  ip_protocol                  = "tcp"

  tags = local.tags
}
