variable "aws_cloud_provider" {
  description = "The default provider"
  type        = string
}

variable "env_prefix" {
  description = "Location Prefix for all AWS Types"
  type        = string
}

variable "public_cidr_block" {
  description = "Defines what the CIDR block is for the CBA Public Subnet"
  type        = string
}

variable "vpc_cidr_block" {
  description = "Defines overall VPC CIDR block"
  type        = string
}

