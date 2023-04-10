variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

/* -------------------------------------------------------------------------- */
/*                           Cluster configurations                           */
/* -------------------------------------------------------------------------- */
variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type        = string
}

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
variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
  default     = "t2.micro"
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  type        = number
  default     = 10
}

variable "ami" {
  description = "The AMI to run in the cluster"
  type        = string
  default     = "ami-062550af7b9fa7d05"
}

variable "server_text" {
  description = "The text the web server should return"
  type        = string
  default     = "Hello there, World!"
}

/* -------------------------------------------------------------------------- */
/*                             ASG configurations                             */
/* -------------------------------------------------------------------------- */
variable "asg_custom_tags" {
  description = "Custom tags to set on the Instances in the ASG"
  type        = map(string)
  default     = {}
}

variable "enable_autoscaling" {
  description = "If set to true, enable auto scaling"
  type        = bool
}
