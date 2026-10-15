variable "name" {
    type = string
}

variable "subnet_group_name" {
    type = string
}

variable "security_group_id" {
    type = string
}
variable "db_username" {
    type = string
    default = "appadmin"
}

variable "instance_class" {
    type = string
    default = "db.t3.micro"
}
variable "tags" {
    type = map(string)
    default = {}
}

