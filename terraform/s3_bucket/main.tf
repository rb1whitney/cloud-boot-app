provider "aws" {
  region = "${var.aws_cloud_provider}"
}

resource "aws_s3_bucket" "terraform_state" {
    bucket = "tf-remote-state-storage"
    acl = "private"
    versioning {
        enabled = true
    }
}