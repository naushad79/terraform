variable "ami_name_filter" {
  type        = string
  description = "The ami name filter"
  default     = "amzn2-ami-hvm-2.0.*.*-x86_64-gp2"
}

variable "ami_owner" {
  type        = string
  description = "Account who owns the AMIs"
  default     = "137112412989"
}

variable "instance_type" {
  type        = string
  description = "Instance type to use"
  default     = "t3a.nano"
}
