resource "aws_alb" "main" {
  subnets         = var.vpc.private_subnet_ids
  security_groups = [aws_security_group.alb.id]
  name            = "${local.prefix}-alb"
  tags            = local.tags
}

resource "aws_alb_target_group" "main" {
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc.id
  target_type = "ip"
  name        = "${local.prefix}-tg"
  health_check {
    protocol            = "HTTP"
    port                = var.container_port
    interval            = var.target_group_health_check_config.interval
    matcher             = var.target_group_health_check_config.matcher
    timeout             = var.target_group_health_check_config.timeout
    path                = var.target_group_health_check_config.path
    healthy_threshold   = var.target_group_health_check_config.healthy_threshold
    unhealthy_threshold = var.target_group_health_check_config.unhealthy_threshold
  }

  tags = local.tags
}

resource "aws_alb_listener" "main" {
  load_balancer_arn = aws_alb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.main.arn
    type             = "forward"
  }

  lifecycle {
    replace_triggered_by = [aws_alb_target_group.main]
  }

  tags = local.tags
}
