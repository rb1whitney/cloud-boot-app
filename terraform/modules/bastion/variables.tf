variable "instance_type" {
  description = "AWS instance type"
  type        = string
}

variable "aws_cloud_provider" {
  description = "The default provider"
  type        = string
}

variable "env_prefix" {
  description = "Location Prefix for all AWS Types"
  type        = string
}

variable "cloud_key_name" {
  description = "The keyname to use to access server"
  type        = string
}

variable "image_id" {
  description = "Cloud Boot Image to use"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnets that the application will live"
  type        = list(string)
}

variable "public_cidr_block" {
  description = "Defines what the CIDR block is for the CBA Public Subnet"
  type        = string
}

variable "ssh_access_cidr_block" {
  description = "Defines what network can connect to ssh bastion servers"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID required to bond ELB and security groups to"
  type        = string
}

variable "asg_min" {
  description = "Min numbers of cloud boot app servers in ASG"
  type        = string
}

variable "asg_max" {
  description = "Max numbers of cloud boot app servers in ASG"
  type        = string
}

variable "asg_desired" {
  description = "Desired numbers of cloud boot app servers in ASG"
  type        = string
}

variable "root_volume_size" {
  description = "Size (GB) of the Root Volume backed by EBS"
  type        = string
  default     = "20"
}