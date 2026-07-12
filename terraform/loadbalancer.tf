
resource "aws_lb" "addressbook" {
  name               = "addressbook-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_http.id]
  subnets            = module.vpc.public_subnets

  tags = merge(local.common_tags, {
    Name = "addressbook-alb"
  })
}

resource "aws_lb_target_group" "addressbook" {
  name        = "addressbook-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.prod-vpc.id

  health_check {
    path                = "/"
    matcher             = "200-399"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }

  tags = merge(local.common_tags, {
    Name = "addressbook-tg"
  })
}

resource "aws_lb_listener" "addressbook_http" {
  load_balancer_arn = aws_lb.addressbook.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.addressbook.arn
  }
}
