/* -------------------------------------------------------------------------- */
/*                           Terraform configuration                          */
/* -------------------------------------------------------------------------- */
/* --------------------------------- Backend -------------------------------- */
terraform {
  backend "s3" {
    bucket = "dlongng-terraform-example-up-and-running-state"
    key    = "workspace-example/terraform.tfstate"
    region = "ap-southeast-1"

    dynamodb_table = "dlongng-terraform-example-up-and-running-locks"
    encrypt        = true
  }
}

/* -------------------------------------------------------------------------- */
/*                           Infrastructure details                           */
/* -------------------------------------------------------------------------- */
/* ------------------------- Instance configuration ------------------------- */
resource "aws_instance" "example" {
  ami           = "ami-062550af7b9fa7d05"
  instance_type = "t2.micro"
}
