variable "aws_cloud_provider"   { default = "us-east-1" }
variable "cloud_key_name"       { default = "rb1whitney" }
variable "cba_instance_type"    { default = "t2.micro" }
variable "cba_port"             { default = "8090" }
variable "cba_elb_port"         { default = "80" }
variable "bastion_instance_type"{ default = "t2.micro" }
variable "cba_asg_min"          { default = 1 }
variable "cba_asg_max"          { default = 1 }
variable "cba_asg_desired"      { default = 1 }
// Please see ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-20160627
variable "aws_image_id"         { default = {
                                    "us-east-1" = "ami-2d39803a"
                                  }
                                }
variable "aws_cloud_azs"        { default = {
                                    "us-east-1" = "us-east-1a,us-east-1b"
                                  }
                                }
// Values must be passed in
variable "env_prefix"           { }
variable "public_cidr_block"    { }
variable "ssh_access_cidr_block"{ }
variable "vpc_cidr_block"       { }

module "cloud_domain" {
  source                = "../../modules/cloud_domain"
  availability_zones    = "${lookup(var.aws_cloud_azs, var.aws_cloud_provider)}"
  aws_cloud_provider    = "${var.aws_cloud_provider}"
  env_prefix            = "${var.env_prefix}"
  vpc_cidr_block        = "${var.vpc_cidr_block}"
  public_cidr_block     = "${var.public_cidr_block}"
}

module "bastion" {
  source                = "../../modules/bastion"
  allowed_network       = "${var.ssh_access_cidr_block}"
  availability_zones    = "${lookup(var.aws_cloud_azs, var.aws_cloud_provider)}"
  aws_cloud_provider    = "${var.aws_cloud_provider}"
  cloud_key_name        = "${var.cloud_key_name}"
  env_prefix            = "${var.env_prefix}"
  image_id              = "${lookup(var.aws_image_id, var.aws_cloud_provider)}"
  instance_type         = "${var.bastion_instance_type}"
  public_cidr_block     = "${var.public_cidr_block}"
  ssh_access_cidr_block = "${var.ssh_access_cidr_block}"
  subnet_ids            = "${module.cloud_domain.public_subnets}"
  vpc_id                = "${module.cloud_domain.vpc_id}"
}

module "cloud_boot_app" {
  source                = "../../modules/cloud_boot_app"
  asg_desired           = "${var.cba_asg_desired}"
  asg_max               = "${var.cba_asg_max}"
  asg_min               = "${var.cba_asg_min}"
  availability_zones    = "${lookup(var.aws_cloud_azs, var.aws_cloud_provider)}"
  aws_cloud_provider    = "${var.aws_cloud_provider}"
  bastion_security_group_id = "${module.bastion.bastion_security_group_id}"
  cba_port              = "${var.cba_port}"
  cba_elb_port          = "${var.cba_elb_port}"
  cloud_key_name        = "${var.cloud_key_name}"
  env_prefix            = "${var.env_prefix}"
  image_id              = "${lookup(var.aws_image_id, var.aws_cloud_provider)}"
  instance_type         = "${var.cba_instance_type}"
  subnet_ids            = "${module.cloud_domain.public_subnets}"
  vpc_id                = "${module.cloud_domain.vpc_id}"
}


output "Cloud-Boot-App-Output" {
  value                 = "Location ${var.env_prefix} is available at: ${module.cloud_boot_app.elb_dns_name} with APP ASG: ${module.cloud_boot_app.autoscaling_group_name} and bastion ASG: ${module.bastion.autoscaling_group_name}"
}