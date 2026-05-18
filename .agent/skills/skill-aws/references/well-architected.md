# AWS Best Practices (Advanced 2026)

This guide provides instructions for specialists AWS Solutions Architect. The objective is to ensure that all AWS infrastructure is Secure, Performant, Resilient, and Cost-Optimized according to 2026 standards.

## The AWS "Golden Path" Protocol

### 1. Identity & Governance (The Foundation)
- **Identity Center (SSO)**: MANDATORY. Never use local IAM users. Federate with an external IDP.
- **AWS Organizations & SCPs**: Use Service Control Policies to enforce guardrails (e.g., "Deny deployment outside of approved regions", "Prevent disabling of S3 Public Access Block").
- **Least Privilege**: Use IAM Access Analyzer to refine policies based on active usage.

### 2. Networking (Zero-Trust VPC)
- **Public/Private Split**: Place ALL backend resources (RDS, EC2, Lambda) in private subnets.
- **VPC Endpoints & PrivateLink**: Access AWS services (S3, KMS, DynamoDB) via Interface Endpoints to eliminate traffic over the public internet.
- **Flow Logs & GuardDuty**: MANDATORY. Enable VPC Flow Logs for audit and GuardDuty for threat detection.

### 3. Serverless Excellence
- **Event-Driven**: Favor asynchronous patterns using EventBridge, SQS, and SNS.
- **Step Functions**: Use Step Functions to coordinate Lambda workflows instead of chain-calling functions.
- **Fine-Grained IAM**: Every Lambda function must have a dedicated, least-privilege role. No shared roles.

### 4. Storage & Reliability
- **S3 Hardening**: Enforce "Public Access Block" at the account level. Always use SSE-KMS for encryption.
- **High Availability**: Multi-AZ deployments for RDS and ElastiCache are the baseline.

## Infrastructure as Code (Production-Ready)

- **Terraform Integration**:
  - Always use S3 with DynamoDB locking for state.
  - Enable **S3 Versioning** on the state bucket.
  - Use modularized, versioned infrastructure blocks.
- **CloudFormation/CDK**:
  - Use StackSets for multi-account deployment.
  - Enable Drift Detection.

## Working with Conductor
- **Implement Phase**: Always propose a "Security Checklist" at the start of every AWS-related task.
- **Review Phase**: Use `aws-best-practices` as a filter to reject any implementation that uses public IPs for backend resources or hardcoded credentials.

### Verification CLI Snippets
```bash
# Check for public S3 buckets in the account
aws s3api get-public-access-block --account-id [YOUR_ACCOUNT_ID]

# List VPC interfaces endpoints
aws ec2 describe-vpc-endpoints --filters "Name=vpc-id,Values=[VPC_ID]"
```