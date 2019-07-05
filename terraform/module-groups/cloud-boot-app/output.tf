output "Cloud-Boot-App-Output" {
  value = "Location ${var.env_prefix} is available at: ${module.cloud_boot_app.elb_dns_name} with APP ASG: ${module.cloud_boot_app.autoscaling_group_name} and bastion ASG: ${module.bastion.autoscaling_group_name}"
}
