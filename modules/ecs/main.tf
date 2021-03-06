# ------------------------------------------------------------------------------
# SERVICE
# ------------------------------------------------------------------------------

resource "aws_ecs_service" "service" {
  name            = join("", [replace(var.path, "/", "-"), var.name])
  cluster         = var.cluster
  task_definition = aws_ecs_task_definition.task.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnets
    security_groups  = [aws_security_group.allow_queue.id]
    assign_public_ip = false
  }
}

# ------------------------------------------------------------------------------
# TASK DEFINITION
# ------------------------------------------------------------------------------

resource "aws_ecs_task_definition" "task" {
  family = join("", [replace(var.path, "/", "-"), var.name])
  cpu    = var.cpu
  memory = var.mem

  task_role_arn      = aws_iam_role.task_role.arn
  execution_role_arn = aws_iam_role.task_execution_role.arn

  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  container_definitions = jsonencode([
    {
      name         = var.name
      image        = "${aws_ecr_repository.ecr.repository_url}:${var.image_tag}"
      essential    = true
      portMappings = []
      cpu          = 0
      mountPoints  = []
      volumesFrom  = []
      environment  = [for k, v in var.environment : { name : k, value : v }]
      secrets      = [for k, v in local.secret_arns : { name : k, valueFrom : v }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-region        = data.aws_region.current.name
          awslogs-group         = aws_cloudwatch_log_group.cw_lg.name
          awslogs-stream-prefix = "${var.name}-task"
        }
      }
    }
  ])
}

# ------------------------------------------------------------------------------
# TASK ROLE (Permissions to app inside container)
# ------------------------------------------------------------------------------

resource "aws_iam_role" "task_role" {
  name = "${replace(title(var.name), "-", "")}TaskRole"

  path = "/${var.path}"
  assume_role_policy = jsonencode(
    {
      Version : "2012-10-17",
      Statement : [
        {
          Action : "sts:AssumeRole"
          Effect : "Allow",
          Sid : "",
          Principal : {
            Service : "ecs-tasks.amazonaws.com"
          }
        }
      ]
  })
  inline_policy {
    name = "ReceiveDeleteMessage"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "sqs:ReceiveMessage",
            "sqs:DeleteMessage"
          ],
          "Resource" : var.queue.arn
        }
      ]
    })

  }
}


# ------------------------------------------------------------------------------
# TASK EXECUTION ROLE (permissions to run the container)
# ------------------------------------------------------------------------------

resource "aws_iam_role" "task_execution_role" {
  name = "${replace(title(var.name), "-", "")}TaskExecutionRole"

  path = "/${var.path}"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]

  assume_role_policy = jsonencode(
    {
      Version : "2012-10-17",
      Statement : [
        {
          Action : "sts:AssumeRole"
          Effect : "Allow",
          Sid : "",
          Principal : {
            Service : "ecs-tasks.amazonaws.com"
          }
        }
      ]
  })

  dynamic "inline_policy" {
    for_each = length(local.secret_arns) > 0 ? [1] : []
    content {
      name = "AllowGetParameters"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
          Effect   = "Allow"
          Action   = ["ssm:GetParameters", "kms:Decrypt"]
          Resource = [for k, v in local.secret_arns : v]
        }]
      })
    }
  }
}

# ------------------------------------------------------------------------------
# SECURITY GROUP
# ------------------------------------------------------------------------------

resource "aws_security_group" "allow_queue" {
  name        = join("", [replace(var.path, "/", "-"), var.name])
  description = "Allow access to the queue"
  vpc_id      = var.vpc_id

  egress {
    description      = "Allow all Egress"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

# ------------------------------------------------------------------------------
# DOCKER REPOSITORY
# ------------------------------------------------------------------------------

resource "aws_ecr_repository" "ecr" {
  name                 = join("", [var.path, var.name])
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# ------------------------------------------------------------------------------
# DOCKER REPOSITORY LIFECYCLE POLICY
# ------------------------------------------------------------------------------

resource "aws_ecr_lifecycle_policy" "policy" {
  repository = aws_ecr_repository.ecr.name
  policy = jsonencode({
    rules : [{
      rulePriority : 1,
      description : "Keep only the early 5 images",
      selection : {
        tagStatus : "any",
        countType : "imageCountMoreThan",
        countNumber : 5
      },
      action : {
        type : "expire"
      }
    }]
  })
}

# ------------------------------------------------------------------------------
# CLOUDWATCH LOG GROUP
# ------------------------------------------------------------------------------

resource "aws_cloudwatch_log_group" "cw_lg" {
  name = join("", ["/", var.path, var.name])
}

# ------------------------------------------------------------------------------
# Data
# ------------------------------------------------------------------------------


data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  secret_arns = { for k, v in var.secrets : k =>
    format("arn:aws:ssm:%s:%s:parameter/%s/%s",
      data.aws_region.current.name,
      data.aws_caller_identity.current.account_id,
      var.name,
      v
    )
  }
}

//  "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.name}/${v}"
