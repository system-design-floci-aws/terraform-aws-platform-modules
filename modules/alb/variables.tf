variable "name" {
    type = string
}

variable "vpc_id" {
    type = string
}

variable "public_subnet_ids" {
    type = list(string)
}

variable "security_group_id" {
    type = string
}

variable "app_port" {
    type = number
    default = 8080
}

variable "tags" {
    type = map(string)
    default = {}
}
variable "certificate_arn" {
  description = "Validated ACM certificate ARN for HTTPS"
  type        = string

  validation {
    condition     = length(trimspace(var.certificate_arn)) > 0
    error_message = "An ACM certificate ARN is required."
  }
}