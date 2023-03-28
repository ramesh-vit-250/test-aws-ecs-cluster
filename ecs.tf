resource "aws_ecr_repository" "sample_ecr_repo" {
  name = "sample-ecr-repo"
}

resource "aws_ecs_cluster" "sample_cluster" {
    name         = "sample_cluster"
}

data "aws_iam_policy_document" "ecs_task_execution_role" {
  version        = "2012-10-17"
  statement {
    sid          = ""
    effect       = "Allow"
    actions      = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "aws-iam-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role               = aws_iam_role.ecs_task_execution_role.name
  policy_arn         = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "sample_task" {
    family                        = "sample_task"
    cpu                           = "256"
    memory                        = "512"
    network_mode                  = "awsvpc"
    requires_compatibilities      = ["FARGATE"]
    execution_role_arn            =  aws_iam_role.ecs_task_execution_role.arn 
#    task_role_arn                 = var.task_role_arn

    container_definitions         = jsonencode([
    {
      name                        = "my-app"
      #map accordingly the ECR URL to the image and load the image, removed personal AWS account details
      image                       = "aws_ecr_repository.sample_ecr_repo.01234567890.dkr.ecr.us-east-1.amazonaws.com/sample-ecr-repo:latest"
      portMappings                = [
        {
          containerPort           = 3000
          hostPort                = 3000
          protocol                = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "sample-service" {
  name                            = "sample-service"
  cluster                         = aws_ecs_cluster.sample_cluster.id
  task_definition                 = aws_ecs_task_definition.sample_task.arn
  desired_count                   = 1
  launch_type                     = "FARGATE"

  network_configuration {
    assign_public_ip              = "true"
    security_groups               = [aws_security_group.sample_sg.id]
    subnets                       = ["${aws_subnet.public_subnet_1.id}", "${aws_subnet.public_subnet_2.id}"]
  }

  deployment_controller {
    type                          = "ECS"
  }
}
