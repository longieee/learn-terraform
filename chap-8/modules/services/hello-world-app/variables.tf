/* -------------------------------------------------------------------------- */
/*                           Cluster configurations                           */
/* -------------------------------------------------------------------------- */
variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket for the database's remote state"
  type        = string
}

variable "db_remote_state_key" {
  description = "The path for the database's remote state in S3"
  type        = string
}

/* -------------------------------------------------------------------------- */
/*                           Instance configurations                          */
/* -------------------------------------------------------------------------- */
variable "server_text" {
  description = "The text the web server should return"
  type        = string
  default     = "Hello there, World!"
}

variable "environment" {
  description = "The name of the environment we're deploying to"
  type        = string
}

/* -------------------------------------------------------------------------- */
/*                             ASG configurations                             */
/* -------------------------------------------------------------------------- */
variable "asg_custom_tags" {
  description = "Custom tags to set on the Instances in the ASG"
  type        = map(string)
  default     = {}
}

/* -------------------------------------------------------------------------- */
/*                           Instance configurations                          */
/* -------------------------------------------------------------------------- */
variable "ami" {
  description = "The AMI to run in the cluster"
  type        = string
  default     = "ami-062550af7b9fa7d05"
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
  default     = "t2.micro"

  # Checking for instance type like this can become outdated quickly
  # e.g. what if AWS change the instances of the free tier?

  # condition in a validation block can only reference the surrounding input variable
  # validation {
  #   condition     = contains(["t2.micro", "t3.micro"], var.instance_type)
  #   error_message = "Only free tier is allowed because I'm broke: t2.micro | t3.micro"
  # }
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  type        = number
  default     = 1

  # condition in a validation block can only reference the surrounding input variable
  validation {
    condition     = var.min_size > 0
    error_message = "ASGs can't be empty or we'll have an outage"
  }

  validation {
    condition     = var.min_size <= 2
    error_message = "ASGs must have 2 or fewer instances to not incur any costs (I just want to use the free stuff to learn Terraform)"
  }
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  type        = number
  default     = 10
}

variable "enable_autoscaling" {
  description = "If set to true, enable auto scaling"
  type        = bool
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}
