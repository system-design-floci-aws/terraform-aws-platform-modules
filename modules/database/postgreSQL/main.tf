resource "aws_db_instance" "postgres" {
    identifier = "${var.name}-postgres"

    engine = "postgres"
    instance_class = var.instance_class

    allocated_storage = 20
    storage_type = "gp3"
    storage_encrypted = true

    db_name = "appdb"
    username = var.db_username
    manage_master_user_password = true

    port = 5432

    db_subnet_group_name = var.subnet_group_name

    vpc_security_group_ids = [
        var.security_group_id
    ]
    publicly_accessible = false
    multi_az = false

    backup_retention_period = 0

    # Don't reuse backup_retention_period = 0 or skip_final_snapshot = true as production defaults.
    deletion_protection = false
    skip_final_snapshot = true

    auto_minor_version_upgrade = true

    tags = var.tags
}