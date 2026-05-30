# Terraform Test for Core Infrastructure

variables {
  aws_region           = "us-east-1"
  env_prefix           = "test"
  vpc_id               = "vpc-12345"
  vpc_cidr             = "10.0.0.0/16"
  db_password          = "Password123!"
  oidc_provider_arn    = "arn:aws:iam::123456789012:oidc-provider/test"
  oidc_provider_url    = "oidc.eks.us-east-1.amazonaws.com/id/test"
  namespace            = "test-ns"
  service_account_name = "test-sa"
  db_username          = "admin"
}

run "verify_s3_bucket" {
  command = plan

  assert {
    condition     = aws_s3_bucket.app_assets.bucket == "test-cloud-boot-app-assets"
    error_message = "S3 bucket name does not match expected naming convention"
  }
}

run "verify_rds_encryption" {
  command = plan

  assert {
    condition     = aws_db_instance.mysql.storage_encrypted == true
    error_message = "RDS storage is not encrypted in the plan"
  }
}

run "verify_security_group_ingress" {
  command = plan

  assert {
    condition     = anytrue([for r in aws_security_group.db_sg.ingress : r.from_port == 3306])
    error_message = "Database security group does not allow port 3306"
  }
}
