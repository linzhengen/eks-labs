provider "aws" {
  region = var.region
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "alb-sg-test"
  description = "Security group for example usage with ALB"
  vpc_id      = data.aws_vpc.default.id

  //  ingress_cidr_blocks = ["126.78.246.245/32"]
  ingress_rules = ["http-80-tcp", "all-icmp"]
  egress_rules  = ["all-all"]
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name               = "test-alb"
  load_balancer_type = "application"

  # todo: get value from vpc output
  vpc_id          = data.aws_vpc.default.id
  subnets         = data.aws_subnet_ids.all.ids
  security_groups = [module.security_group.security_group_id]

  http_tcp_listeners = [
    # Forward action is default, either when defined or undefined
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
      action_type        = "forward"
    },
  ]

  http_tcp_listener_rules = [
    {
      http_tcp_listener_index = 0
      priority                = 1
      actions = [{
        type = "forward"
      }]

      conditions = [{
        path_patterns = ["/"]
      }]
    },
  ]

  target_groups = [
    {
      name_prefix          = "index"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "instance"
      deregistration_delay = 10
      health_check         = {}
      protocol_version     = "HTTP1"
      targets              = {}
    },
  ]
}
