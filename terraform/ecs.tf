
resource "aws_cloudwatch_log_group" "addressbook" {
  name              = "/ecs/addressbook"
  retention_in_days = 7

  tags = local.common_tags
}


resource "aws_ecs_cluster" "addressbook" {
  name = "addressbook-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = local.common_tags
}

resource "aws_ecs_task_definition" "addressbook" {
  family                   = "addressbook"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "addressbook"
      image     = "${aws_ecr_repository.addressbook.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.addressbook.name
          awslogs-region        = data.aws_region.current.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = local.common_tags
}

resource "aws_ecs_service" "addressbook" {
  name            = "addressbook-service"
  cluster         = aws_ecs_cluster.addressbook.id
  task_definition = aws_ecs_task_definition.addressbook.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  health_check_grace_period_seconds = 120
  force_new_deployment = true

  network_configuration {
    subnets          = module.vpc.private_subnets
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.addressbook.arn
    container_name   = "addressbook"
    container_port   = 8080
  }

  depends_on = [aws_lb_listener.addressbook_http]

  tags = local.common_tags
}