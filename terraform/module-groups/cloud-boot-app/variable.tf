variable "aws_cloud_provider" {
  default = "us-east-1"
}

variable "cloud_key_name" {
  default = "rb1whitney"
}

variable "cba_instance_type" {
  default = "t2.micro"
}

variable "cba_port" {
  default = "8090"
}

variable "cba_elb_port" {
  default = "80"
}

variable "bastion_instance_type" {
  default = "t2.micro"
}

variable "cba_asg_min" {
  default = 1
}

variable "cba_asg_max" {
  default = 1
}

variable "cba_asg_desired" {
  default = 1
}

variable "bastion_asg_min" {
  default = 1
}

variable "bastion_asg_max" {
  default = 1
}

variable "bastion_asg_desired" {
  default = 1
}

// Values must be passed in
variable "env_prefix" {
}

variable "public_cidr_block" {
  type = string
}

variable "ssh_access_cidr_block" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "ami_owner" {
  description = "Owner of the AMI to reduce search requirement for a unique AMI (defaults to Canonical)"
  type        = string
  default     = "099720109477"

}

variable "ami_name" {
  description = "AMI to use on bastion and cloud boot app auto-scaling groups"
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20190628"
}