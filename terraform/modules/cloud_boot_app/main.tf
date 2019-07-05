provider "aws" {
  region = "${var.aws_cloud_provider}"
}

resource "aws_security_group" "cba_lb" {
  description = "Ensures Elastic Load Balancer can load balancer application servers"
  name        = "${var.env_prefix}-sg-cba-lb"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = "${var.cba_elb_port}"
    to_port     = "${var.cba_elb_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "load_balancer"
  }
}

resource "aws_security_group" "cba_app" {
  description = "Ensures that we can communicate with cloud boot application from outside"
  name        = "${var.env_prefix}-cba-app"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = "${var.cba_port}"
    to_port     = "${var.cba_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "cba"
  }
}

resource "aws_security_group" "cba_elb" {
  description = "Ensures we can communicate with load balancer port and return all traffic"
  name        = "${var.env_prefix}-cloud-boot-app-elb"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "${var.cba_elb_port}"
    to_port     = "${var.cba_elb_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "load_balancer_cba"
  }
}

// Passes port to user data script for EC2 instances (can pass sh file too if you want)
data "template_file" "cba_userdata" {
  template = "${file("${path.module}/user-data/cloud-boot-app-userdata.tpl")}"

  vars {
    cba_port_ri   = "${var.cba_port}"
    env_prefix_ri = "${var.env_prefix}"
  }
}

resource "aws_elb" "cba_elb" {
  name    = "${var.env_prefix}-elb-cloud-boot-app"
  subnets = ["${var.subnet_ids}"]

  security_groups = [
    "${aws_security_group.cba_elb.id}",
    "${var.bastion_security_group_id}",
  ]

  listener {
    instance_port     = "${var.cba_port}"
    instance_protocol = "http"
    lb_port           = "${var.cba_elb_port}"
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    interval            = 30
    target              = "HTTP:${var.cba_port}/cloud-boot-app/version"
    timeout             = 3
    unhealthy_threshold = 2
  }
}

resource "aws_launch_configuration" "cba_app" {
  associate_public_ip_address = "true"
  image_id                    = "${var.image_id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.cloud_key_name}"

  security_groups = [
    "${aws_security_group.cba_lb.id}",
    "${aws_security_group.cba_app.id}",
    "${var.bastion_security_group_id}",
  ]

  user_data = "${data.template_file.cba_userdata.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "cba_app" {
  desired_capacity     = "${var.asg_desired}"
  force_delete         = false
  health_check_type    = "ELB"
  launch_configuration = "${aws_launch_configuration.cba_app.id}"
  load_balancers       = ["${aws_elb.cba_elb.name}"]
  max_size             = "${var.asg_max}"
  min_size             = "${var.asg_min}"
  name                 = "${var.env_prefix}-asg-cba"
  vpc_zone_identifier  = ["${var.subnet_ids}"]

  tag {
    key                 = "Name"
    value               = "${var.env_prefix}-cba-server"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "${var.env_prefix}-cba"
    propagate_at_launch = true
  }
}
