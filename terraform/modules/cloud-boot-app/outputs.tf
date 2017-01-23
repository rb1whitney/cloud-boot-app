output "elb_dns_name" {
  value = "${aws_elb.elb_cloud_boot_app.dns_name}"
}

output "aws_region" {
  value = "${var.aws_cloud_provider}"
}

output "autoscaling_group_name" {
  value = "${aws_autoscaling_group.asg_cloud_boot_app.name}"
}