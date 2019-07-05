variable "cba_port" {
  description = "The port the server will use for HTTP requests"
}

variable "cba_elb_port" {
  description = "The port the server will use for HTTP requests"
}

variable "instance_type" {
  description = "AWS instance type"
}

variable "asg_min" {
  description = "Min numbers of cloud boot app servers in ASG"
}

variable "asg_max" {
  description = "Max numbers of cloud boot app servers in ASG"
}

variable "asg_desired" {
  description = "Desired numbers of cloud boot app servers in ASG"
}

variable "aws_cloud_provider" {
  description = "The default provider"
}

variable "env_prefix" {
  description = "Location Prefix for all AWS Types"
}

variable "cloud_key_name" {
  description = "The keyname to use to access server"
}

variable "availability_zones" {
  description = "Defines what availability zones will be used by the application. A private and public subnet will be associated with each availability zone"
}

variable "image_id" {
  description = "Cloud Boot Image to use docker on"
}

variable "bastion_security_group_id" {
  description = "Bastion Group ID that will be allowed to ssh into these boxes"
}

variable "subnet_ids" {
  description = "List of subnets that the application will live"
  type        = "list"
}

variable "vpc_id" {
  description = "VPC ID required to bond ELB and security groups to"
}
