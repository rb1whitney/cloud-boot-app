output "cloud_boot_app_output" {
  description = "Summary of the Cloud Boot App deployment status and locations"
  value       = "Location ${var.env_prefix} is available at: ${module.cloud_boot_app.elb_dns_name} with APP ASG: ${module.cloud_boot_app.autoscaling_group_name} and bastion ASG: ${module.bastion.autoscaling_group_name}"
}
