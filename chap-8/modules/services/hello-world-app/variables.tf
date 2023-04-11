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
