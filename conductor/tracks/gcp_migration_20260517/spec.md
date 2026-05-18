# Technical Specification: AWS to GCP Migration

## 1. Goal
Migrate the `cloud-boot-app` core infrastructure from AWS to Google Cloud Platform (GCP). All resource patterns must be re-platformed to GCP native counterparts, maintaining high-security configurations, development-tier sizing, and production-grade monitoring.

## 2. Resource Mapping Table

| Component | AWS Resource | GCP Native Equivalent | Specifications |
| :--- | :--- | :--- | :--- |
| **Object Storage** | `aws_s3_bucket` | `google_storage_bucket` | Uniform bucket-level access enabled, public access prevention enforced, encryption at rest. |
| **Relational DB** | `aws_db_instance` (MySQL 8.0) | `google_sql_database_instance` | MySQL 8.0 engine, db-f1-micro tier, Private IP connectivity, automatic backups, and High Availability (HA). |
| **VPC Firewall** | `aws_security_group` | `google_compute_firewall` | Restricts ingress to Cloud SQL on port 3306 exclusively to the GKE subnet. |
| **Pod Authentication**| `aws_iam_role` (OIDC IRSA) | `google_service_account` + Workload Identity | Binds GCP Service Account to GKE namespace/service account utilizing Workload Identity bindings. |
| **Observability** | `sre-monitoring.tf` placeholder | `google_monitoring_dashboard` | Real monitoring dashboard tracking the 4 Golden Signals (Latency, Traffic, Errors, Saturation). |

## 3. Directory Standards
- Archive active AWS configurations to `terraform/aws/` folder to maintain clear migration lineage.
- Keep `terraform/core/` clean and populated exclusively with the active GCP configurations.
- Verify syntactical correctness via `terraform fmt` and `terraform validate`.
