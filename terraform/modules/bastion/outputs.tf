output "aws_region" {
  description = "The AWS region where the bastion host is deployed"
  value       = var.aws_cloud_provider
}

output "autoscaling_group_name" {
  description = "The name of the Auto Scaling Group for the bastion host"
  value       = aws_autoscaling_group.bastion.name
}

output "bastion_security_group_id" {
  description = "The ID of the security group that allows access from the bastion host"
  value       = aws_security_group.allow_bastion.id
}
