resource "aws_ecs_cluster" "this" {
    name = "${var.name}-cluster"
    tags = var.tags
}

resource "aws_cloudwatch_log_group" "app" {
    name = "/ecs/${var.name}"
    retention_in_days = 7
    tags = var.tags
}

resource "aws_ecs_task_definition" "app" {
    family = "${var.name}-task"
    requires_compatibilities = ["FARGATE"]
    network_mode = "awsvpc"

    cpu = "256"
    memory = "512"

    execution_role_arn = var.execution_role_arn
    task_role_arn = var.task_role_arn

    runtime_platform {
        operating_system_family = "LINUX"
        cpu_architecture = "X86_64"
    }

    container_definitions = jsonencode([
        {
            name = "python-app"
            image = var.image
            essential = true

            portMappings = [
                {
                    containerPort = var.app_port
                    hostPort = var.app_port
                    protocol = "tcp"
                }
            ]

            logConfiguration = {
                logDriver = "awslogs"
                options = {
                    awslogs-group = aws_cloudwatch_log_group.app.name
                    awslogs-region = var.aws_region
                    awslogs-stream-prefix = "ecs"
                }
            }
        }
    ])
}

resource "aws_ecs_service" "app" {
    name = "${var.name}-service"
    cluster = aws_ecs_cluster.this.id
    task_definition = aws_ecs_task_definition.app.arn

    launch_type = "FARGATE"
    desired_count = var.desired_count

    deployment_minimum_healthy_percent = 50
    deployment_maximum_percent = 200

    network_configuration {
        subnets = var.private_subnet_ids
        security_groups = [var.security_group_id]
        assign_public_ip = false
    }

    load_balancer {
        target_group_arn = var.target_group_arn
        container_name = "python-app"
        container_port =var.app_port
    }

    deployment_circuit_breaker {
        enable = true
        rollback = true
    }
    tags = var.tags
}