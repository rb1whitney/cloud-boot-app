variable "availability_zones" {
  description           = "Defines what availability zones will be used by the application. A private and public subnet will be associated with each availability zone"
}

variable "aws_cloud_provider" {
  description           = "The default provider"
}

variable "env_prefix" {
  description           = "Location Prefix for all AWS Types"
}

variable "public_cidr_block" {
  description           = "Defines what the CIDR block is for the CBA Public Subnet"
}

variable "vpc_cidr_block" {
  description           = "Defines overall VPC CIDR block"
}