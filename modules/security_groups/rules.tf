#############################
# Internet -> ALB :HTTPS
#############################
resource "aws_vpc_security_group_ingress_rule" "alb_https" {
    security_group_id = aws_security_group.alb.id
    description = "Allow inbound HTTPS"
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 443
    to_port = 443
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "alb_http_dev" {
  security_group_id = aws_security_group.alb.id

  description = "Local development HTTP access"

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}

#############################
# ALB -> APPLICATION: 8080
#############################
resource "aws_vpc_security_group_egress_rule" "alb_to_app" {
    security_group_id = aws_security_group.alb.id
    description = "Allow ALB to reach application"

    # allowed destination
    referenced_security_group_id = aws_security_group.app.id

    from_port = var.app_port
    to_port = var.app_port
    ip_protocol = "tcp"
}
#############################
# App <- ALB
#############################
resource "aws_vpc_security_group_ingress_rule" "app_from_alb" {
  security_group_id = aws_security_group.app.id

  description = "Allow application requests from ALB"

  referenced_security_group_id = aws_security_group.alb.id

  from_port   = var.app_port
  to_port     = var.app_port
  ip_protocol = "tcp"

}
#############################
# Application -> Database
#############################
resource "aws_vpc_security_group_egress_rule" "app_to_db" {
    security_group_id = aws_security_group.app.id
    description = "Allow application to connect to Database"

    referenced_security_group_id = aws_security_group.db.id

    from_port = var.db_port
    to_port = var.db_port
    ip_protocol = "tcp"    
}

# Database accepts traffic ONLY from application

resource "aws_vpc_security_group_ingress_rule" "db_from_app" {
    security_group_id = aws_security_group.db.id
    description = " Allow database traffic from Application"

    referenced_security_group_id = aws_security_group.app.id

    from_port = var.db_port
    to_port = var.db_port
    ip_protocol = "tcp"
}