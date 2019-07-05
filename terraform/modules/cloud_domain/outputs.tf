output "public_subnets" {
  value = ["${aws_subnet.public_cba.*.id}"]
}

output "vpc_id" {
  value = "${aws_vpc.vpc_cba.id}"
}
