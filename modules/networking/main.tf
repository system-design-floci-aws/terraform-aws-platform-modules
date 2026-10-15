locals {
  name = "${var.project_name}-${var.environment}"
  common_tags = merge(var.tags, {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  })
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = "${local.name}-vpc"
  cidr = var.vpc_cidr
  azs  = var.availability_zones

  public_subnets   = var.public_subnets
  private_subnets  = var.private_app_subnets
  database_subnets = var.private_db_subnets

  enable_dns_support   = true
  enable_dns_hostnames = true
  create_igw           = true

  # Public load balancers receive IPs through the AWS service; EC2 instances
  # launched in these subnets do not automatically receive a public IP.
  map_public_ip_on_launch = false

  # Deliberate default: private app instances have no general IPv4 internet egress.
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.enable_nat_gateway ? var.single_nat_gateway : false

  # Database routes are separated from app routes; no default IGW/NAT route.
  create_database_subnet_group           = true
  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = false
  create_database_nat_gateway_route      = false

  # Never treat default NACL management as a replacement for security groups.
  manage_default_network_acl = true

  tags                 = local.common_tags
  vpc_tags             = { Tier = "network" }
  public_subnet_tags   = { Tier = "public" }
  private_subnet_tags  = { Tier = "application" }
  database_subnet_tags = { Tier = "database" }
}
