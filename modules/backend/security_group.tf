locals {
  alb_sg_name = "${local.prefix}-alb-"
  ecs_sg_name = "${local.prefix}-ecs-"
}

resource "aws_security_group" "alb" {
  name_prefix = local.alb_sg_name
  description = "Allow inbound traffic from outside on ${var.container_port} port."

  vpc_id = var.vpc.id

  tags = local.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb" {
  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = aws_alb_listener.main.port
  to_port     = aws_alb_listener.main.port
  ip_protocol = "tcp"

  tags = local.tags
}

resource "aws_vpc_security_group_egress_rule" "alb" {
  security_group_id = aws_security_group.alb.id

  referenced_security_group_id = aws_security_group.ecs.id
  ip_protocol                  = "-1"

  tags = local.tags
}

resource "aws_security_group" "ecs" {
  name_prefix = local.ecs_sg_name
  description = "Allow inbound traffic from ALB on ${var.container_port} port."

  vpc_id = var.vpc.id

  tags = local.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "ecs" {
  security_group_id = aws_security_group.ecs.id

  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = var.container_port
  to_port                      = var.container_port
  ip_protocol                  = "tcp"

  tags = local.tags
}

resource "aws_vpc_security_group_egress_rule" "ecs" {
  security_group_id = aws_security_group.ecs.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  tags = local.tags
}
