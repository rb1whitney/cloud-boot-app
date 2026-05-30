variable "aws_region" {
  description = "The AWS region to deploy resources into"
  type        = string
  default     = "us-east-1"
}

variable "env_prefix" {
  description = "Prefix for resource naming"
  type        = string
  default     = "dev"
}

variable "vpc_id" {
  description = "The VPC ID to deploy into"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block of the VPC for security group rules"
  type        = string
}

variable "db_username" {
  description = "Username for the RDS instance"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Password for the RDS instance"
  type        = string
  sensitive   = true
}

variable "oidc_provider_arn" {
  description = "The ARN of the OIDC provider for IRSA"
  type        = string
}

variable "oidc_provider_url" {
  description = "The URL of the OIDC provider for IRSA"
  type        = string
}

variable "namespace" {
  description = "The Kubernetes namespace for the application"
  type        = string
  default     = "cloud-boot-app"
}

variable "service_account_name" {
  description = "The Kubernetes service account name for IRSA"
  type        = string
  default     = "cloud-boot-app"
}
