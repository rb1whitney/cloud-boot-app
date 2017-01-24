provider "aws" {
  region                = "${var.aws_cloud_provider}"
}

resource "aws_security_group" "sg_cloud_boot_app_default" {
  name                  = "${var.env_prefix}-sg-cloud-boot-app-default"
  description           = "Ensures SSH and HTTP are available to incoming traffic and enable all traffic leaving the cloud."

  ingress {
    from_port           = 22
    to_port             = 22
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
  }

  ingress {
    from_port           = 80
    to_port             = 80
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
  }

  egress {
    from_port           = 0
    to_port             = 0
    protocol            = "-1"
    cidr_blocks         = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_cloud_boot_app" {
  name                  = "${var.env_prefix}-cloud-boot-app-incoming-port"
  description           = "Ensures that we can communicate with cloud boot application"

  ingress {
    from_port           = "${var.cloud_boot_server_port}"
    to_port             = "${var.cloud_boot_server_port}"
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
  }

  lifecycle {
      create_before_destroy = true
  }
}

resource "aws_security_group" "sg_elb" {
  name                  = "${var.env_prefix}-cloud-boot-app-elb"
  description           = "Ensures we can communicate over load balancer port and return all traffic"

  egress {
      from_port         = 0
      to_port           = 0
      protocol          = "-1"
      cidr_blocks       = ["0.0.0.0/0"]
  }

  ingress {
    from_port           = "${var.cloud_boot_elb_port}"
    to_port             = "${var.cloud_boot_elb_port}"
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "lc_cloud_boot_app" {
  image_id              = "${var.cloud_boot_server_image_id}"
  instance_type         = "${var.cloud_boot_server_instance_type}"
  key_name              = "${var.cloud_key_name}"
  security_groups       = ["${aws_security_group.sg_cloud_boot_app.id}", "${aws_security_group.sg_cloud_boot_app_default.id}"]
  user_data             = "${file("${path.module}/cloud-boot-app-userdata.sh")}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "elb_cloud_boot_app" {
  availability_zones    = ["${data.aws_availability_zones.all.names}"]
  security_groups       = ["${aws_security_group.sg_elb.id}"]
  name                  = "${var.env_prefix}-elb-cloud-boot-app"

  listener {
    instance_port       = "${var.cloud_boot_server_port}"
    instance_protocol   = "http"
    lb_port             = "${var.cloud_boot_elb_port}"
    lb_protocol         = "http"
  }

  health_check {
    healthy_threshold   = 2
    interval            = 30
    target              = "HTTP:${var.cloud_boot_server_port}/cloud-boot-app/version"
    timeout             = 3
    unhealthy_threshold = 2
  }
}

resource "aws_autoscaling_group" "asg_cloud_boot_app" {
  availability_zones    = ["${data.aws_availability_zones.all.names}"]
  desired_capacity      = "${var.cloud_boot_server_asg_desired}"
  force_delete          = true
  health_check_type     = "ELB"
  launch_configuration  = "${aws_launch_configuration.lc_cloud_boot_app.id}"
  load_balancers        = ["${aws_elb.elb_cloud_boot_app.name}"]
  max_size              = "${var.cloud_boot_server_asg_max}"
  min_size              = "${var.cloud_boot_server_asg_min}"
  name                  = "${var.env_prefix}-asg-cloud-boot-app"

  tag {
    key                 = "Name"
    value               = "${var.env_prefix}-cloud-boot-app-server"
    propagate_at_launch = true
  }
}