variable "aws_cloud_provider"               { }
variable "env_prefix"                       { }
variable "cloud_key_name"                   { }
variable "cloud_boot_server_image_id"       { }
variable "cloud_boot_server_instance_type"  { }
variable "cloud_boot_server_asg_min"        { }
variable "cloud_boot_server_asg_max"        { }
variable "cloud_boot_server_asg_desired"    { }

# Use the Cloud Boot App Module
module "cloud-boot-app" {
  source                            = "../../modules/cloud-boot-app"
  aws_cloud_provider                = "${var.aws_cloud_provider}"
  cloud_key_name                    = "${var.cloud_key_name}"
  env_prefix                        = "${var.env_prefix}"
  cloud_boot_server_image_id        = "${var.cloud_boot_server_image_id}"
  cloud_boot_server_instance_type   = "${var.cloud_boot_server_instance_type}"
  cloud_boot_server_asg_min         = "${var.cloud_boot_server_asg_min}"
  cloud_boot_server_asg_max         = "${var.cloud_boot_server_asg_max}"
  cloud_boot_server_asg_desired     = "${var.cloud_boot_server_asg_desired}"
}

output "Cloud-Boot-App-Output" {
  value = "Location ${var.env_prefix} is available at: ${module.cloud-boot-app.elb_dns_name} with ASG: ${module.cloud-boot-app.autoscaling_group_name}"
}