# Track: AWS to GCP Migration (2026-05-17)

This track details the migration of `cloud-boot-app`'s core infrastructure from AWS to GCP.

## Status Dashboard
- **Current State**: Planning.
- **Health**: 🟩 Nominal.
- **Risk**: ⬜ Low.

## Milestones

### [ ] Milestone 1: AWS Archive & Cleanup
- [ ] Create `terraform/aws` directory.
- [ ] Move active AWS configurations out of `terraform/core` to the archive directory.

### [ ] Milestone 2: GCP Native Re-platforming
- [ ] Implement variables.tf with GCP-native inputs.
- [ ] Implement GCS, Cloud SQL, Compute Firewall, and Workload Identity resources in main.tf.

### [ ] Milestone 3: SRE Observability & Validation
- [ ] Create `google_monitoring_dashboard` resource tracking the four Golden Signals.
- [ ] Validate syntax and formatting.
