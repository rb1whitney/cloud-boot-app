variable "aws_cloud_provider" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "us-east-1"
}

variable "cloud_key_name" {
  description = "Name of the SSH key pair to use for EC2 instances"
  type        = string
  default     = "rb1whitney"
}

variable "cba_instance_type" {
  description = "EC2 instance type for the Cloud Boot App"
  type        = string
  default     = "t2.micro"
}

variable "cba_port" {
  description = "Port the Cloud Boot App listens on"
  type        = string
  default     = "8090"
}

variable "cba_elb_port" {
  description = "Port the ELB listens on for the Cloud Boot App"
  type        = string
  default     = "80"
}

variable "bastion_instance_type" {
  description = "EC2 instance type for the bastion host"
  type        = string
  default     = "t2.micro"
}

variable "cba_asg_min" {
  description = "Minimum size of the Cloud Boot App ASG"
  type        = number
  default     = 1
}

variable "cba_asg_max" {
  description = "Maximum size of the Cloud Boot App ASG"
  type        = number
  default     = 1
}

variable "cba_asg_desired" {
  description = "Desired capacity of the Cloud Boot App ASG"
  type        = number
  default     = 1
}

variable "bastion_asg_min" {
  description = "Minimum size of the bastion ASG"
  type        = number
  default     = 1
}

variable "bastion_asg_max" {
  description = "Maximum size of the bastion ASG"
  type        = number
  default     = 1
}

variable "bastion_asg_desired" {
  description = "Desired capacity of the bastion ASG"
  type        = number
  default     = 1
}

// Values must be passed in
variable "env_prefix" {
  description = "Prefix for resource naming based on environment"
  type        = string
}

variable "public_cidr_block" {
  description = "CIDR block for public subnets"
  type        = string
}

variable "ssh_access_cidr_block" {
  description = "CIDR block allowed to SSH into bastion"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "ami_owner" {
  description = "Owner of the AMI to reduce search requirement for a unique AMI (defaults to Canonical)"
  type        = string
  default     = "099720109477"
}

variable "ami_name" {
  description = "AMI name pattern to use on bastion and cloud boot app auto-scaling groups"
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20190628"
}
