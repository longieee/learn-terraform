provider "aws" {
  region = "ap-southeast-1"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

module "alb" {
  source = "github.com/longieee/learn-terraform//chap-8/modules/networking/alb?ref=v1.8.3"

  alb_name   = "my-alb-example"
  subnet_ids = data.aws_subnets.default.ids
}
