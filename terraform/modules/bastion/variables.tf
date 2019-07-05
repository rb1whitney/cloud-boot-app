variable "instance_type" {
  description = "AWS instance type"
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

variable "allowed_network" {
  description = "Allowed network to ssh to our bastion servers"
}

variable "availability_zones" {
  description = "Defines what availability zones will be used by the application. A private and public subnet will be associated with each availability zone"
}

variable "image_id" {
  description = "Cloud Boot Image to use"
}

variable "subnet_ids" {
  description = "List of subnets that the application will live"
  type        = "list"
}

variable "public_cidr_block" {
  description = "Defines what the CIDR block is for the CBA Public Subnet"
}

variable "ssh_access_cidr_block" {
  description = "Defines what network can connect to ssh bastion servers"
}

variable "vpc_id" {
  description = "VPC ID required to bond ELB and security groups to"
}
