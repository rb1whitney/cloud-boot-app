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

// Please see ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-20160627
variable "aws_image_id" {
  default = {
    "us-east-1" = "ami-2d39803a"
  }
}

variable "aws_cloud_azs" {
  default = {
    "us-east-1" = "us-east-1a,us-east-1b"
  }
}

// Values must be passed in
variable "env_prefix" {}

variable "public_cidr_block" {}
variable "ssh_access_cidr_block" {}
variable "vpc_cidr_block" {}
