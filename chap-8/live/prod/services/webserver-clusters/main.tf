provider "aws" {
  region = "ap-southeast-1"
}

module "hello_world_app" {
  source = "github.com/longieee/learn-terraform//chap-8/modules/services/hello-world-app?ref=v1.8.4"

  server_text = "Hello again, New Production with Zero_Downtime!"

  environment = "prod"

  db_remote_state_bucket = "dlongng-terraform-example-up-and-running-state"
  db_remote_state_key    = "prod/data-stores/mysql/terraform.tfstate"

  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 5
  asg_custom_tags = {
    Owner     = "dlongng"
    ManagedBy = "terraform"
  }

  enable_autoscaling = true
}


