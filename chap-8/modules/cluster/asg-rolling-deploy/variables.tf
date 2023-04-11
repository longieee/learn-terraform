/* -------------------------------------------------------------------------- */
/*                           Cluster configurations                           */
/* -------------------------------------------------------------------------- */
variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type        = string
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

variable "enable_autoscaling" {
  description = "If set to true, enable auto scaling"
  type        = bool
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
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
/*                             VPC configurations                             */
/* -------------------------------------------------------------------------- */
variable "subnet_ids" {
  description = "The subnet IDs to deploy to"
  type        = list(string)
}

variable "target_group_arns" {
  description = "The ARNs of ELB target groups in which to register Instances"
  type        = list(string)
  default     = []
}

variable "health_check_type" {
  description = "The type of health check to perform. Must be one of: EC2, ELB."
  type        = string
  default     = "EC2"
}

variable "user_data" {
  description = "The User Data script to run in each Instance at boot"
  type        = string
  default     = "null"
}
