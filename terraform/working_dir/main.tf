module "cloud_domain" {
  source             = "../../modules/cloud_domain"
  availability_zones = "${lookup(var.aws_cloud_azs, var.aws_cloud_provider)}"
  aws_cloud_provider = "${var.aws_cloud_provider}"
  env_prefix         = "${var.env_prefix}"
  vpc_cidr_block     = "${var.vpc_cidr_block}"
  public_cidr_block  = "${var.public_cidr_block}"
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
  source                    = "../../modules/cloud_boot_app"
  asg_desired               = "${var.cba_asg_desired}"
  asg_max                   = "${var.cba_asg_max}"
  asg_min                   = "${var.cba_asg_min}"
  availability_zones        = "${lookup(var.aws_cloud_azs, var.aws_cloud_provider)}"
  aws_cloud_provider        = "${var.aws_cloud_provider}"
  bastion_security_group_id = "${module.bastion.bastion_security_group_id}"
  cba_port                  = "${var.cba_port}"
  cba_elb_port              = "${var.cba_elb_port}"
  cloud_key_name            = "${var.cloud_key_name}"
  env_prefix                = "${var.env_prefix}"
  image_id                  = "${lookup(var.aws_image_id, var.aws_cloud_provider)}"
  instance_type             = "${var.cba_instance_type}"
  subnet_ids                = "${module.cloud_domain.public_subnets}"
  vpc_id                    = "${module.cloud_domain.vpc_id}"
}
