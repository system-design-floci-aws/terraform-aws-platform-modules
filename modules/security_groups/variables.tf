variable "vpc_id" {
  description = "VPC where security groups will be created."
  type        = string
}

variable "project_name" {
  description = "Project name."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "app_port" {
  description = "Application container listening port."
  type        = number
  default     = 8080

  validation {
    condition     = var.app_port >= 1 && var.app_port <= 65535
    error_message = "Port must be between 1 and 65535."
  }
}

variable "db_port" {
  description = "PostgreSQL listening port."
  type        = number
  default     = 5432
}

variable "tags" {
  description = "Additional resource tags."
  type        = map(string)
  default     = {}
}