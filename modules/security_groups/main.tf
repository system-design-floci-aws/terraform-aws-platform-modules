locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = merge(
    var.tags,
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  )
}

##################################
# Security Group for ALB
##################################
resource "aws_security_group" "alb" {
  name_prefix = "${local.name_prefix}-alb-"
  description = "Security group for public ALB"
  vpc_id      = var.vpc_id

  revoke_rules_on_delete = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-alb-sg"
    Tier = "public"
  })
}

##################################
# Security Group for Application
##################################
resource "aws_security_group" "app" {
  name_prefix = "${local.name_prefix}-app-"
  description = "Security group for private application workloads"
  vpc_id      = var.vpc_id

  revoke_rules_on_delete = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-app-sg"
    Tier = "application"
  })
}

##################################
# Security Group for database
##################################
resource "aws_security_group" "db" {
  name_prefix = "${local.name_prefix}-db-"
  description = "Security group for private PostgreSQL"
  vpc_id      = var.vpc_id

  revoke_rules_on_delete = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-db-sg"
    Tier = "database"
  })
}

# We don't want unlimited outbound connectivity by default.
# Instead, we explicitly authorize the traffic needed by each tier.
# egress {
#   from_port   = 0
#   to_port     = 0
#   protocol    = "-1"
#   cidr_blocks = ["0.0.0.0/0"]
# }