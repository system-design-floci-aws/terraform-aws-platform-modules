variable "project_name" {
  description = "Short project identifier, used for resource names and tags."
  type        = string
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,30}$", var.project_name))
    error_message = "project_name must start with a lowercase letter and contain 2-31 lowercase letters, digits or hyphens."
  }
}

variable "environment" {
  type        = string
  description = "Deployment environment."
  validation {
    condition     = contains(["dev", "qa", "staging", "prod"], var.environment)
    error_message = "environment must be dev, qa, staging or prod."
  }
}

variable "vpc_cidr" {
  type        = string
  description = "IPv4 CIDR for the VPC."
  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "Provide a valid IPv4 CIDR."
  }
}

variable "availability_zones" {
  type        = list(string)
  description = "Two or more distinct availability zones."
  validation {
    condition     = length(var.availability_zones) >= 2 && length(distinct(var.availability_zones)) == length(var.availability_zones)
    error_message = "Supply at least two unique AZs."
  }
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnet IPv4 CIDRs, AZ order."
  validation {
    condition     = alltrue([for c in var.public_subnets : can(cidrnetmask(c))])
    error_message = "Every public subnet must have a valid IPv4 CIDR."
  }
}

variable "private_app_subnets" {
  type        = list(string)
  description = "Private application subnet IPv4 CIDRs, AZ order."
  validation {
    condition     = alltrue([for c in var.private_app_subnets : can(cidrnetmask(c))])
    error_message = "Every application subnet must have a valid IPv4 CIDR."
  }
}

variable "private_db_subnets" {
  type        = list(string)
  description = "Isolated database subnet IPv4 CIDRs, AZ order."
  validation {
    condition     = alltrue([for c in var.private_db_subnets : can(cidrnetmask(c))])
    error_message = "Every database subnet must have a valid IPv4 CIDR."
  }
}

variable "enable_nat_gateway" {
  description = "Allow general outbound internet access from private application subnets. Incurs costs."
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Use one NAT gateway (cheaper, not AZ-resilient); false deploys multiple NAT gateways when enabled."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional common tags. Reserved tags are set by the module."
  type        = map(string)
  default     = {}
}
