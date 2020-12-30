resource "aws_ecs_cluster" "fargate" {
  name = "${var.namespace}-aws_ecs_cluster_name"
  capacity_providers = [
    "FARGATE"]
}

resource "aws_ecs_task_definition" "sample_app" {
  family = "sample_app_svc"
  memory = "2048"
  container_definitions = jsonencode(
  [
    {
      essential = true
      healthCheck = {
        command = [
          "curl http://localhost:8080/sample_app/time",
        ]
        interval = 30
        retries = 3
        timeout = 5
      }
      image = "324671914464.dkr.ecr.us-west-2.amazonaws.com/microservice-sample-ecr:latest"
      name = "sample_app"
      requires_compatibilities = [
        "FARGATE",
      ]
    }
  ]
  )
}

resource "aws_iam_role" "sample_app_role" {
  name = "sample_app_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [ "ecs.amazonaws.com", "ecs-tasks.amazonaws.com" ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

module "alb" {
  source = "terraform-aws-modules/alb/aws"
  version = "~> 4.0"
  load_balancer_name = "${var.namespace}-alb"
  security_groups = [
    var.sg.lb]
  subnets = var.vpc.public_subnets
  vpc_id = var.vpc.vpc_id
  logging_enabled = false
  http_tcp_listeners = [
    {
      port = 80,
      protocol = "HTTP"
    }]
  http_tcp_listeners_count = "1"
  target_groups = [
    {
      name = "websvr",
      backend_protocol = "HTTP",
      backend_port = 8080
    }]
  target_groups_count = "1"
}
resource "aws_lb_target_group" "lb_target_group" {
  name = "target-group"
  port = 8080
  protocol = "HTTP"
  vpc_id = var.vpc.vpc_id
  target_type = "ip"
}

resource "aws_ecs_service" "sample_app_service" {
  name = "sample-app-service"
  cluster = aws_ecs_cluster.fargate.id
  task_definition = aws_ecs_task_definition.sample_app.arn
  desired_count = 1
  iam_role = aws_iam_role.sample_app_role.arn
  depends_on = [
    aws_iam_role.sample_app_role]
  ordered_placement_strategy {
    type = "binpack"
    field = "cpu"
  }
  network_configuration {
    assign_public_ip = false
    security_groups = [
      var.sg.websvr
    ]
    subnets = [
      var.vpc.private_subnets
    ]
  }
  load_balancer {
    container_name = "sample_app_container"
    container_port = 8080
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }

}