output "db_endpoint" {
  value = aws_db_instance.postgres.address
}

output "db_port" {
  value = aws_db_instance.postgres.port
}

output "db_identifier" {
  value = aws_db_instance.postgres.identifier
}

output "master_secret_arn" {
  description = "ARN of the RDS-managed master credential"
  value       = try(
    aws_db_instance.postgres.master_user_secret[0].secret_arn,
    null
  )
}