locals {
  lb_sg_name  = "${local.prefix}-lb-"
  ecs_sg_name = "${local.prefix}-ecs-"
}

data "aws_ec2_managed_prefix_list" "vpc_origin" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}

resource "aws_security_group" "lb" {
  name_prefix = local.lb_sg_name
  description = "Allow inbound traffic from outside on port 80."

  vpc_id = var.vpc.id

  tags = local.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "lb" {
  security_group_id = aws_security_group.lb.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = aws_lb_listener.main.port
  to_port     = aws_lb_listener.main.port
  ip_protocol = "tcp"

  tags = local.tags
}

resource "aws_vpc_security_group_ingress_rule" "vpc_origin" {
  security_group_id = aws_security_group.lb.id

  prefix_list_id = data.aws_ec2_managed_prefix_list.vpc_origin.id
  from_port      = aws_lb_listener.main.port
  to_port        = aws_lb_listener.main.port
  ip_protocol    = "tcp"

  tags = local.tags
}

resource "aws_vpc_security_group_egress_rule" "lb" {
  security_group_id = aws_security_group.lb.id

  referenced_security_group_id = aws_security_group.ecs.id
  ip_protocol                  = "-1"

  tags = local.tags
}

resource "aws_security_group" "ecs" {
  name_prefix = local.ecs_sg_name
  description = "Allow inbound traffic from lb on ${var.container_port} port."

  vpc_id = var.vpc.id

  tags = local.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "ecs" {
  security_group_id = aws_security_group.ecs.id

  referenced_security_group_id = aws_security_group.lb.id
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
