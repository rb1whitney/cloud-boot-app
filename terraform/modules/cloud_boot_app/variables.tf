variable "cba_port" {
  description = "The port the server will use for HTTP requests"
  type        = string
}

variable "cba_elb_port" {
  description = "The port the server will use for HTTP requests"
  type        = string
}

variable "instance_type" {
  description = "AWS instance type"
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
  description = "Cloud Boot Image to use docker on"
  type        = string
}

variable "bastion_security_group_id" {
  description = "Bastion Group ID that will be allowed to ssh into these boxes"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnets that the application will live"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID required to bond ELB and security groups to"
  type        = string
}

variable "root_volume_size" {
  description = "Size (GB) of the Root Volume backed by EBS"
  type        = string
  default     = "20"
}

variable "ebs_volume_size" {
  description = "Size (GB) of the Root Volume backed by EBS"
  type        = string
  default     = "10"
}

variable "ebs_device_name" {
  description = "Path of the EBS Volume"
  type        = string
  default     = "/dev/sdb"
}
