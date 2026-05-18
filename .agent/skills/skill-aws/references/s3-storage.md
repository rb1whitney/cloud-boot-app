# AWS Reference: S3 Storage & RDS Databases

Following the AWS Well-Architected Framework: Performance and Cost Pillars.

## 1. Amazon S3 Hardening
- **Public Access Block**: Enabled at the account level. No public buckets unless explicitly required and audited.
- **Encryption**: Default SSE-S3 or SSE-KMS for all objects. Enforce "Encryption in Transit" via bucket policies.
- **Versioning & MFA Delete**: Protect against accidental deletion and ransomware.
- **Lifecycle Policies**: Automatically move objects to cheaper tiers (IA, Glacier) or expire them after a set period.

## 2. Amazon RDS / Aurora
- **High Availability (Multi-AZ)**: Mandatory for production to provide automated failover.
- **Backup & Recovery**: Automated snapshots with cross-region replication for disaster recovery.
- **Storage Autoscaling**: Automatically increases storage capacity as the workload grows.
- **Performance Insights**: Detailed monitoring of database performance and SQL query execution.

## 3. Distributed caching & NoSQL
- **DynamoDB**: Scalable, serverless NoSQL with global tables for regional resilience.
- **ElastiCache**: In-memory caching (Redis/Memcached) to reduce database load and improve latency.

## 4. Cost Optimization
- **Right-sizing**: Choosing the appropriate instance classes (m6g, r6g) based on CPU/RAM usage.
- **Reserved Instances / Savings Plans**: Committing to usage for significant discounts.
- **Audit**: Using AWS Trusted Advisor to identify underutilized resources.