# AWS Reference: Zero-Trust VPC & Networking

Following the AWS Well-Architected Framework: Reliability and Security Pillars.

## 1. VPC Architecture
- **Private-First Design**: ALL backend resources (DBs, App Servers) must be in private subnets with NO direct internet route.
- **NAT Gateway / NAT Instance**: Used for outbound-only internet access for private subnets.
- **Transit Gateway**: Centralized hub for connecting multiple VPCs and on-premise networks at scale.

## 2. Secure Connectivity
- **VPC Endpoints (Interface & Gateway)**: Access AWS services (S3, KMS, DynamoDB) privately without leaving the AWS network. This is the foundation of Zero-Trust.
- **PrivateLink**: Sharing services across VPCs and accounts without exposing them to the public internet.
- **Client VPN & Site-to-Site VPN**: Secure access for developers and branch offices.

## 3. Threat Detection & Visibility
- **VPC Flow Logs**: Enabled for all subnets. Integrated with Amazon GuardDuty for automated threat detection.
- **Security Groups**: State-based, instance-level protection. Favor "Least Privilege" rules based on other security groups rather than CIDR blocks.
- **Network ACLs**: Stateless, subnet-level protection. Use as a secondary layer of defense (e.g., blocking known malicious IP ranges).

## 4. Global Traffic Management
- **Route 53**: Global DNS with health checks and failover routing.
- **CloudFront & AWS WAF**: Global distribution with L7 security filtering for web applications.
- **Global Accelerator**: Optimizing performance for global users by routing traffic over the AWS global network.