variable "name" {
    type = string
}

variable "aws_region" {
    type = string
}

variable "private_subnet_ids" {
    type = list(string)
}

variable "security_group_id" {
    type = string
}

variable "target_group_arn" {
    type = string
}

variable "execution_role_arn" {
    type = string
}

variable "task_role_arn" {
    type = string
}

variable "image" {
    type = string
}

variable "app_port" {
    type = number 
    default = 8080
}

variable "desired_count" {
    type = number 
    default = 0
    validation {
        condition = var.desired_count >=0
        error_message = "ECS desired count can't be negative"
    }
}

variable "tags" {
    type = map(string)
    default = {}
}