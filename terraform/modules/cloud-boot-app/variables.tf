variable "cloud_boot_server_port" {
  description = "The port the server will use for HTTP requests"
  default = 8080
}

variable "cloud_boot_elb_port" {
  description = "The port the server will use for HTTP requests"
  default = 80
}

variable "cloud_boot_server_image_id" {
  default     = "ami-2d39803a"
  description = "AWS instance type"
}

variable "cloud_boot_server_instance_type" {
  default     = "t2.micro"
  description = "AWS instance type"
}

variable "cloud_boot_server_asg_min" {
  description = "Min numbers of cloud boot app servers in ASG"
  default     = "1"
}

variable "cloud_boot_server_asg_max" {
  description = "Max numbers of cloud boot app servers in ASG"
  default     = "4"
}

variable "cloud_boot_server_asg_desired" {
  description = "Desired numbers of cloud boot app servers in ASG"
  default     = "2"
}

variable "aws_cloud_provider" {
  description = "The default provider"
  default = "us-east-1"
}

variable "env_prefix" {
  default     = "rwhitney"
  description = "Location Prefix for all AWS Types"
}

variable "cloud_key_name" {
  description = "The keyname to use to access server"
  default = "rb1whitney"
}

# List all availability zones
data "aws_availability_zones" "all" {}