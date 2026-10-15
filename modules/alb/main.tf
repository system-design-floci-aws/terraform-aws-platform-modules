resource "aws_lb" "this" {
    name = "${var.name}-alb"
    internal = false
    load_balancer_type = "application"

    security_groups = [var.security_group_id]
    subnets = var.public_subnet_ids

    enable_deletion_protection = false

    tags = var.tags
}

resource "aws_lb_target_group" "app" {
    name = "${var.name}-tg"
    port = var.app_port
    protocol = "HTTP"
    target_type = "ip"
    vpc_id = var.vpc_id

    health_check {
        enabled = true
        path    = "/health"
        protocol = "HTTP"
        matcher  = "200"
        healthy_threshold = 2
        unhealthy_threshold =3
        interval = 30
        timeout = 5
    }

    tags = var.tags
}

# local deployment only : HTTP listner

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.this.arn

    port = 80
    protocol = "HTTP"

    default_action {
        type = "redirect"
        
        redirect {
            port        = "443"
            protocol    = "HTTPS"
            status_code = "HTTP_301"
        }
    }
    tags = var.tags
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn

  port            = 443
  protocol        = "HTTPS"
  certificate_arn = var.certificate_arn

  ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  tags = var.tags
}


