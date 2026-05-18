# Implementation Plan: AWS to GCP Migration

## Phase 1: Reorganize & Archive AWS Configurations
- [ ] Create `terraform/aws` directory <!-- [id: 0] -->
- [ ] Move `terraform/core/main.tf` to `terraform/aws/main.tf` <!-- [id: 1] -->
- [ ] Move `terraform/core/variables.tf` to `terraform/aws/variables.tf` <!-- [id: 2] -->
- [ ] Move `terraform/core/sre-monitoring.tf` to `terraform/aws/sre-monitoring.tf` <!-- [id: 3] -->

## Phase 2: Implement GCP HCL Configurations
- [ ] Define GCP provider variables in `terraform/core/variables.tf` <!-- [id: 4] -->
- [ ] Implement native GCS, Cloud SQL, Compute Firewall, and Workload Identity resources in `terraform/core/main.tf` <!-- [id: 5] -->

## Phase 3: SRE Observability (Golden Signals)
- [ ] Implement `google_monitoring_dashboard` resource in `terraform/core/sre-monitoring.tf` <!-- [id: 6] -->

## Phase 4: Validation & Quality Control
- [ ] Execute `terraform fmt -recursive` <!-- [id: 7] -->
- [ ] Execute `terraform validate` inside `terraform/core` <!-- [id: 8] -->
