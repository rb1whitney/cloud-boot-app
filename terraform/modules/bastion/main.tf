provider "aws" {
  region = "${var.aws_cloud_provider}"
}

resource "aws_security_group" "bastion" {
  description = "Rules allows access to SSH"
  name        = "${var.env_prefix}-bastion"
  vpc_id      = "${var.vpc_id}"

  ingress = {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.allowed_network}"]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.public_cidr_block}"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "bastion"
  }
}

resource "aws_security_group" "allow_bastion" {
  description = "Allow specific access from bastion host to other cloud resources"
  name        = "${var.env_prefix}-cba-bastion"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.bastion.id}"]
    self            = false
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "allow_bastion"
  }
}

resource "aws_launch_configuration" "bastion" {
  associate_public_ip_address = "true"
  image_id                    = "${var.image_id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.cloud_key_name}"
  security_groups             = ["${aws_security_group.bastion.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bastion" {
  desired_capacity     = "${length(split(",", var.availability_zones))}"
  force_delete         = false
  health_check_type    = "EC2"
  launch_configuration = "${aws_launch_configuration.bastion.id}"
  max_size             = "${length(split(",", var.availability_zones))}"
  min_size             = "${length(split(",", var.availability_zones))}"
  name                 = "${var.env_prefix}-asg-bastion"
  vpc_zone_identifier  = ["${var.subnet_ids}"]

  tag {
    key                 = "Name"
    value               = "${var.env_prefix}-bastion-server"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "${var.env_prefix}-bastion"
    propagate_at_launch = true
  }
}
