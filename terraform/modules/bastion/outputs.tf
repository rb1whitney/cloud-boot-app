output "aws_region" {
  value = var.aws_cloud_provider
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.bastion.name
}

output "bastion_security_group_id" {
  value = aws_security_group.allow_bastion.id
}

