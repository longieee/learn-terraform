terraform {
  backend "s3" {
    bucket = "dlongng-terraform-example-up-and-running-state"
    key    = "global/s3/terraform.tfstate"
    region = "ap-southeast-1"

    dynamodb_table = "dlongng-terraform-example-up-and-running-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

/* ------------------------ Shared storage definition ----------------------- */
resource "aws_s3_bucket" "terraform_state" {
  bucket = "dlongng-terraform-example-up-and-running-state"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_lock" {
  name         = "dlongng-terraform-example-up-and-running-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
