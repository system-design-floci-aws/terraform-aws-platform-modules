check "subnet_layout" {
  assert {
    condition = (
      length(var.public_subnets) == length(var.availability_zones) &&
      length(var.private_app_subnets) == length(var.availability_zones) &&
      length(var.private_db_subnets) == length(var.availability_zones)
    )
    error_message = "Provide exactly one subnet of each tier per AZ."
  }
}

# Additional CIDR containment/overlap checks belong in CI (ipaddress script or
# policy checks). Terraform's cidrnetmask validation only checks syntax.
