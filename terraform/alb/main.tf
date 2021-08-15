provider "aws" {
  region = var.region
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "test-alb"
  load_balancer_type = "application"

  # todo: get value from vpc output
  vpc_id             = ""
  subnets            = []
  security_groups    = []

  # todo: https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/latest
}
