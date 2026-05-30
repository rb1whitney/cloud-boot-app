output "public_subnets" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public_cba[*].id
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc_cba.id
}
