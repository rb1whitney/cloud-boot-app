provider "aws" {
  region = var.aws_cloud_provider
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "tf-remote-state-storage"
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "terraform_state" {
  depends_on = [aws_s3_bucket_ownership_controls.terraform_state]

  bucket = aws_s3_bucket.terraform_state.id
  acl    = "private"
}
