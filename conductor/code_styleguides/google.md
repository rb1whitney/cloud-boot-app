# Google Cloud Platform Style Guide

Standards for writing GCP infrastructure code across Terraform, gcloud CLI, GKE, and Cloud IAM.

**References:** [Google Cloud Architecture Framework](https://cloud.google.com/architecture/framework) | [GCP Best Practices](https://cloud.google.com/docs/enterprise/best-practices-for-enterprise-organizations) | [Google Terraform Modules](https://registry.terraform.io/namespaces/terraform-google-modules)

## Project and Resource Hierarchy

GCP uses a 3-tier hierarchy: Organization → Folder → Project. Every resource lives in a project.

```
organization/
├── folder: production/
│   ├── project: myapp-prod-vpc-host     # Shared VPC host project
│   └── project: myapp-prod              # Service project
└── folder: non-production/
    ├── project: myapp-dev
    └── project: myapp-staging
```

**Rules**:
- Use separate projects per environment (not separate namespaces in one project)
- Use Shared VPC for network isolation between service projects
- Project IDs are globally unique and immutable — format: `{org}-{app}-{env}`

## Naming Conventions

Pattern: `{project-id}-{resource-type}[-{qualifier}]`

| Resource | Pattern | Example |
|---|---|---|
| GCS bucket | `{project-id}-{purpose}` | `myorg-myapp-prod-artifacts` |
| GKE cluster | `{app}-{env}-{region}` | `myapp-prod-us-central1` |
| Cloud SQL | `{app}-{env}-{engine}` | `myapp-prod-postgres` |
| Service account | `{role}-sa@{project}.iam.gserviceaccount.com` | `gke-node-sa@myapp-prod.iam.gserviceaccount.com` |
| Firewall rule | `{network}-allow-{proto}-{source}` | `myapp-vpc-allow-https-lb` |
| Subnet | `{network}-{region}-{tier}` | `myapp-vpc-us-central1-private` |

**Rules**:
- All lowercase, hyphens only (no underscores — Cloud Run and GKE names prohibit them)
- GCS bucket names must be globally unique — prefix with project ID
- Service account display names use sentence case

## Labels Strategy

GCP uses labels (equivalent to AWS tags) for cost allocation and filtering.

```hcl
locals {
  common_labels = {
    environment  = var.environment          # dev | staging | prod
    project      = var.app_name             # lowercase-hyphenated
    managed_by   = "terraform"
    team         = var.team_name
    cost_center  = var.cost_center
  }
}
```

Label key/value rules: lowercase letters, numbers, hyphens, underscores only. Max 63 chars per key/value.

## IAM and Service Accounts

```hcl
# Never use default service accounts — create purpose-specific ones
resource "google_service_account" "gke_nodes" {
  account_id   = "gke-node-sa"
  display_name = "GKE Node Service Account"
  description  = "Minimal permissions for GKE node pool"
  project      = var.project_id
}

# Grant only required roles with conditions where possible
resource "google_project_iam_member" "gke_nodes_logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

# Avoid primitive roles (roles/owner, roles/editor, roles/viewer)
# Use predefined roles or custom roles with minimal permissions
```

**Forbidden roles** in production:
- `roles/owner`
- `roles/editor`
- `roles/iam.serviceAccountTokenCreator` (except for Workload Identity)

## GCS Bucket Hardening

```hcl
resource "google_storage_bucket" "artifacts" {
  name                        = "${var.project_id}-artifacts"
  location                    = var.region
  project                     = var.project_id
  uniform_bucket_level_access = true  # Always enable — disables legacy ACLs
  force_destroy               = false # Never true in production

  versioning {
    enabled = true
  }

  encryption {
    default_kms_key_name = google_kms_crypto_key.gcs.id
  }

  lifecycle_rule {
    condition { age = 30 }
    action { type = "SetStorageClass"; storage_class = "NEARLINE" }
  }

  lifecycle_rule {
    condition { age = 365 }
    action { type = "SetStorageClass"; storage_class = "COLDLINE" }
  }

  labels = local.common_labels
}

# Block public access at bucket level
resource "google_storage_bucket_iam_binding" "no_public" {
  bucket  = google_storage_bucket.artifacts.name
  role    = "roles/storage.objectViewer"
  members = []  # Empty = no public access
}
```

## GKE Cluster Best Practices

```hcl
resource "google_container_cluster" "main" {
  name     = "${var.app_name}-${var.environment}-${var.region}"
  location = var.region  # Regional cluster (not zonal) for HA
  project  = var.project_id

  # Remove default node pool — manage node pools separately
  remove_default_node_pool = true
  initial_node_count       = 1

  # Workload Identity — the correct way to give pods GCP permissions
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # Private cluster — no public node IPs
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false  # Allow kubectl from authorized networks
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = var.admin_cidr
      display_name = "Corporate VPN"
    }
  }

  # Enable network policy (Calico)
  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  # Binary Authorization for supply chain security
  binary_authorization {
    evaluation_mode = "PROJECT_SINGLETON_POLICY_ENFORCE"
  }
}
```

## Cloud Run Conventions

```hcl
resource "google_cloud_run_v2_service" "api" {
  name     = "${var.app_name}-api"
  location = var.region
  project  = var.project_id

  ingress = "INGRESS_TRAFFIC_ALL"

  template {
    service_account = google_service_account.cloud_run.email

    scaling {
      min_instance_count = 1   # Prevent cold starts in production
      max_instance_count = 10
    }

    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/${var.repo}/${var.image}:${var.tag}"

      resources {
        limits = {
          cpu    = "1"
          memory = "512Mi"
        }
      }

      env {
        name = "PROJECT_ID"
        value = var.project_id
      }

      # Secrets from Secret Manager — never inline
      env {
        name = "DB_PASSWORD"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.db_password.secret_id
            version = "latest"
          }
        }
      }
    }
  }
}
```

## gcloud CLI Conventions

```bash
# Always set project and region to avoid implicit defaults
gcloud config set project myapp-prod
gcloud config set compute/region us-central1

# Use --format for machine-readable output
gcloud compute instances list --format="table(name,zone,status,machineType)"

# Use --filter for server-side filtering (faster than grep)
gcloud compute instances list --filter="status=RUNNING AND tags.items=web"

# Access secrets — never from env vars directly
gcloud secrets versions access latest --secret=db-password --project=myapp-prod

# Impersonate service accounts for testing permissions
gcloud compute instances list \
  --impersonate-service-account=gke-node-sa@myapp-prod.iam.gserviceaccount.com
```

## Code Review Checklist

- [ ] No default service accounts used — purpose-specific SAs with minimal roles
- [ ] No primitive roles (`owner`, `editor`, `viewer`) in production
- [ ] GCS buckets have `uniform_bucket_level_access = true`
- [ ] GCS buckets use CMEK (customer-managed encryption keys)
- [ ] GKE cluster is regional (not zonal) and private
- [ ] GKE uses Workload Identity (not service account key files)
- [ ] Cloud Run services use Secret Manager (not hardcoded env vars)
- [ ] All resources labeled with mandatory label set
- [ ] Resource names follow lowercase-hyphen pattern

---

*Based on: [Google Cloud Architecture Framework](https://cloud.google.com/architecture/framework) and [GCP Enterprise Best Practices](https://cloud.google.com/docs/enterprise/best-practices-for-enterprise-organizations)*
