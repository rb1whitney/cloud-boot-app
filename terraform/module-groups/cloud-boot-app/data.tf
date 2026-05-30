data "aws_ami_ids" "ubuntu" {
  owners = [var.ami_owner]

  filter {
    name   = "name"
    values = [var.ami_name]
  }
}