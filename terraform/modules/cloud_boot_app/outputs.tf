output "aws_region" {
  description = "The AWS region where the Cloud Boot App is deployed"
  value       = var.aws_cloud_provider
}

output "autoscaling_group_name" {
  description = "The name of the Auto Scaling Group for the Cloud Boot App"
  value       = aws_autoscaling_group.cba_app.name
}

output "elb_dns_name" {
  description = "The DNS name of the Elastic Load Balancer for the Cloud Boot App"
  value       = aws_elb.cba_elb.dns_name
}
