provider "aws" {
  profile = "devender-personal"
  region = "us-west-2"
}

variable "live" {
  default = "blue"
}

module "base" {
  source = "scottwinkler/aws/bluegreen//modules/base"
  production = var.live
}

module "green" {
  source = "scottwinkler/aws/bluegreen//modules/autoscaling"
  app_version = "v1.0"
  base = module.base
  group = "green"
}

module "blue" {
  source = "scottwinkler/aws/bluegreen//modules/autoscaling"
  app_version = "v2.0"
  base = module.base
  group = "blue"
}

output "lb_dns_name" {
  value = module.base.lb_dns_name
}