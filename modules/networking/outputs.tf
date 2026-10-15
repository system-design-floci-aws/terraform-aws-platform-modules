output "vpc_id" {
  description = "VPC ID."
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "VPC IPv4 CIDR."
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = module.vpc.public_subnets
}

output "private_app_subnet_ids" {
  description = "Private application subnet IDs."
  value       = module.vpc.private_subnets
}

output "private_db_subnet_ids" {
  description = "Database subnet IDs."
  value       = module.vpc.database_subnets
}

output "database_subnet_group_name" {
  description = "DB subnet group name for RDS."
  value       = module.vpc.database_subnet_group_name
}
