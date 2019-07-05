provider "aws" {
  region = "${var.aws_cloud_provider}"
}

resource "aws_vpc" "vpc_cba" {
  cidr_block = "${var.vpc_cidr_block}"

  tags {
    description = "VPC for cloud boot app location ${var.env_prefix}"
    name        = "${var.env_prefix}-cba-vpc"
  }
}

resource "aws_internet_gateway" "ig_cba" {
  vpc_id = "${aws_vpc.vpc_cba.id}"

  tags {
    description = "Creates internet gateway for cloud boot app location ${var.env_prefix}"
    name        = "${var.env_prefix}-cba-internet-gateway"
  }
}

resource "aws_subnet" "public_cba" {
  availability_zone = "${element(split(",", var.availability_zones), count.index)}"
  cidr_block        = "${cidrsubnet(var.public_cidr_block, 3, count.index)}"
  count             = "${length(split(",", var.availability_zones))}"
  vpc_id            = "${aws_vpc.vpc_cba.id}"
}

resource "aws_route_table" "public_cba" {
  count  = "${length(split(",", var.availability_zones))}"
  vpc_id = "${aws_vpc.vpc_cba.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ig_cba.id}"
  }

  tags {
    name        = "${var.env_prefix}-cba-public-route-table"
    description = "Ensures traffic goes through internet gateway from public subnet"
  }
}

resource "aws_route_table_association" "public_cba" {
  route_table_id = "${element(aws_route_table.public_cba.*.id, count.index)}"
  subnet_id      = "${element(aws_subnet.public_cba.*.id, count.index)}"
  count          = "${length(split(",", var.availability_zones))}"
}
