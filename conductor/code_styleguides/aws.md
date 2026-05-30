# AWS Infrastructure Style Guide

Standards for writing AWS infrastructure code across Terraform, CloudWatch, IAM, and CLI automation.

**References:** [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/) | [AWS Security Best Practices](https://docs.aws.amazon.com/security/) | [AWS Tagging Best Practices](https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html)

## Tagging Strategy

All AWS resources must be tagged. Tags are the primary mechanism for cost allocation, compliance tracking, and automation.

```hcl
# Required tags on every resource
locals {
  required_tags = {
    Environment = var.environment          # dev | staging | prod
    Project     = var.project_name         # lowercase-hyphenated
    ManagedBy   = "Terraform"              # Terraform | Manual | Packer
    Owner       = var.team_name            # team or individual responsible
    CostCenter  = var.cost_center          # billing allocation code
  }
}
```

**Mandatory tags**: `Environment`, `Project`, `ManagedBy`, `Owner`
**Recommended tags**: `CostCenter`, `DataClassification`, `Compliance`, `Backup`

## Naming Conventions

Pattern: `{project}-{environment}-{resource-type}[-{qualifier}]`

| Resource | Pattern | Example |
|---|---|---|
| VPC | `{project}-{env}-vpc` | `myapp-prod-vpc` |
| Subnet | `{project}-{env}-{az}-{tier}` | `myapp-prod-use1a-private` |
| EC2 | `{project}-{env}-{role}-{index}` | `myapp-prod-web-01` |
| RDS | `{project}-{env}-{engine}` | `myapp-prod-postgres` |
| S3 bucket | `{account-id}-{project}-{env}-{purpose}` | `123456789-myapp-prod-data` |
| IAM role | `{project}-{env}-{service}-role` | `myapp-prod-lambda-role` |
| Security group | `{project}-{env}-{tier}-sg` | `myapp-prod-web-sg` |
| KMS key alias | `alias/{project}-{env}-{purpose}` | `alias/myapp-prod-rds` |

**Rules**:
- Lowercase only, hyphens as separator (not underscores — most AWS services prohibit them in names)
- S3 bucket names must include account ID prefix to ensure global uniqueness
- Never use generic names like `default`, `test`, `temp` in production

## IAM Least Privilege Pattern

```hcl
# Never use wildcard actions in production
# Bad
resource "aws_iam_policy" "bad" {
  policy = jsonencode({
    Statement = [{
      Effect   = "Allow"
      Action   = "*"
      Resource = "*"
    }]
  })
}

# Good — specific actions, specific resources
resource "aws_iam_policy" "s3_read" {
  name        = "${var.project}-${var.environment}-s3-read"
  description = "Read-only access to the data bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3ReadData"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
        ]
        Resource = [
          aws_s3_bucket.data.arn,
          "${aws_s3_bucket.data.arn}/*",
        ]
      }
    ]
  })
}
```

## Security Group Rules

```hcl
# Bad — open to the internet
resource "aws_security_group_rule" "bad" {
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  type        = "ingress"
}

# Good — reference security group IDs, never CIDR for internal traffic
resource "aws_security_group_rule" "alb_to_web" {
  description              = "Allow HTTPS from ALB to web tier"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = aws_security_group.web.id
}

# Egress — be explicit, never use -1 (all traffic)
resource "aws_security_group_rule" "web_egress_https" {
  description       = "Allow HTTPS egress to internet for package updates"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web.id
}
```

## S3 Bucket Hardening

Every S3 bucket requires:

```hcl
resource "aws_s3_bucket_public_access_block" "data" {
  bucket                  = aws_s3_bucket.data.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "data" {
  bucket = aws_s3_bucket.data.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "data" {
  bucket = aws_s3_bucket.data.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3.arn
    }
    bucket_key_enabled = true  # Reduces KMS costs by 99%
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "data" {
  bucket = aws_s3_bucket.data.id
  rule {
    id     = "transition-and-expire"
    status = "Enabled"
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }
}
```

## CloudWatch Alarms — Standard Thresholds

```hcl
# EC2 CPU alarm
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.project}-${var.environment}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "CPU exceeds 80% for 3 consecutive minutes"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }
}
```

## KMS Key Policy Pattern

```hcl
resource "aws_kms_key" "rds" {
  description             = "${var.project}-${var.environment}-rds encryption key"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = local.required_tags
}

resource "aws_kms_alias" "rds" {
  name          = "alias/${var.project}-${var.environment}-rds"
  target_key_id = aws_kms_key.rds.key_id
}
```

## Remote State Configuration

```hcl
terraform {
  backend "s3" {
    bucket         = "{account-id}-{project}-terraform-state"
    key            = "{environment}/{service}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    kms_key_id     = "alias/{project}-terraform-state"
    dynamodb_table = "{project}-terraform-state-lock"
  }
}
```

## AWS CLI Conventions

```bash
# Always specify region and output format explicitly
aws ec2 describe-instances \
  --region us-east-1 \
  --output json \
  --query 'Reservations[].Instances[?State.Name==`running`].[InstanceId,Tags[?Key==`Name`].Value|[0]]' \
  --output table

# Use --profile for named credential sets
aws s3 ls --profile prod-readonly

# Never pipe secrets — use parameter store
aws ssm get-parameter \
  --name "/${var.project}/${var.environment}/db/password" \
  --with-decryption \
  --query Parameter.Value \
  --output text
```

## Code Review Checklist

- [ ] All resources tagged with mandatory tag set
- [ ] Resource names follow `{project}-{env}-{type}` pattern
- [ ] No wildcard IAM actions (`Action: "*"`)
- [ ] Security groups use SG references for internal traffic (not CIDR)
- [ ] No `0.0.0.0/0` ingress on sensitive ports (22, 3306, 5432)
- [ ] S3 buckets have public access block + encryption + versioning
- [ ] KMS keys have rotation enabled and 30-day deletion window
- [ ] Remote state backend uses S3 + DynamoDB locking + encryption
- [ ] No credentials hardcoded — use IAM roles or Parameter Store

---

*Based on: [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/) and [AWS Security Best Practices](https://docs.aws.amazon.com/security/)*
