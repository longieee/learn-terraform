provider "aws" {
  region = "ap-southeast-1"
}

module "webserver_cluster" {
  source = "../../../../modules/services/webserver-cluster"

  cluster_name           = "webservers-prod"
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


