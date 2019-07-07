output "aws_region" {
  value = var.aws_cloud_provider
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.cba_app.name
}

output "elb_dns_name" {
  value = aws_elb.cba_elb.dns_name
}

