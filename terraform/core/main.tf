# Core Infrastructure for Cloud Boot App
# Provisioned via Terraform for AWS

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# 1. S3 Bucket for App Assets
resource "aws_s3_bucket" "app_assets" {
  bucket = "${var.env_prefix}-cloud-boot-app-assets"

  tags = {
    Name        = "App Assets"
    Environment = var.env_prefix
    Project     = "cloud-boot-app"
  }
}

resource "aws_s3_bucket_public_access_block" "app_assets_block" {
  bucket = aws_s3_bucket.app_assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 2. RDS MySQL Instance
resource "aws_db_instance" "mysql" {
  allocated_storage                   = 20
  storage_type                        = "gp2"
  engine                              = "mysql"
  engine_version                      = "8.0"
  instance_class                      = "db.t3.micro"
  db_name                             = "cloudbootapp"
  username                            = var.db_username
  password                            = var.db_password
  skip_final_snapshot                 = true
  publicly_accessible                 = false
  storage_encrypted                   = true
  vpc_security_group_ids              = [aws_security_group.db_sg.id]
  iam_database_authentication_enabled = true
  multi_az                            = true
  deletion_protection                 = true
  auto_minor_version_upgrade          = true
  monitoring_interval                 = 60
  monitoring_role_arn                 = aws_iam_role.rds_monitoring.arn
  enabled_cloudwatch_logs_exports     = ["error", "general", "slowquery"]

  tags = {
    Name        = "Cloud Boot App DB"
    Environment = var.env_prefix
  }
}

# 2.1 RDS Monitoring Role
resource "aws_iam_role" "rds_monitoring" {
  name = "${var.env_prefix}-rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rds_monitoring" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# 3. Security Group for Database
resource "aws_security_group" "db_sg" {
  name        = "${var.env_prefix}-cloud-boot-app-db-sg"
  description = "Allow access to MySQL from app subnet"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow MySQL traffic from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr] # Restrict to VPC CIDR
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 4. IAM Role for App (to be used by Kubernetes IRSA)
resource "aws_iam_role" "app_role" {
  name = "${var.env_prefix}-cloud-boot-app-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = var.oidc_provider_arn
        }
        Condition = {
          StringEquals = {
            "${var.oidc_provider_url}:sub" : "system:serviceaccount:${var.namespace}:${var.service_account_name}"
          }
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "s3_access" {
  name = "S3Access"
  role = aws_iam_role.app_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Effect = "Allow"
        Resource = [
          aws_s3_bucket.app_assets.arn,
          "${aws_s3_bucket.app_assets.arn}/*"
        ]
      },
    ]
  })
}
