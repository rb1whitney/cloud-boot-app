# Implementation Plan: Hardening & Intuition

## Phase 1: Structure Cleanup
- [DONE] Initialize track and documentation <!-- [id: 0] -->
- [DONE] Create `docs/` and `logs/` directories <!-- [id: 1] -->
- [DONE] Move `architectural.md` to `docs/architecture.md` <!-- [id: 2] -->
- [DONE] Move `dep_tree_final.log` to `docs/archive/dependency-tree.log` <!-- [id: 3] -->
- [DONE] Move `terraform/find_auto_scaling_group_instances.sh` to `bin/find_asg_instances.sh` <!-- [id: 4] -->
- [DONE] Move `terraform/terraform_wrapper.sh` to `bin/terraform_wrapper.sh` <!-- [id: 5] -->
- [DONE] Create `terraform/core/sre-monitoring.tf` with functional observability resources <!-- [id: 6] -->

## Phase 2: Agentic Hardening
- [DONE] Generate `bin/audit_app.sh` <!-- [id: 7] -->
- [DONE] Generate `bin/audit_aws.sh` <!-- [id: 8] -->
- [DONE] Generate `bin/audit_github.sh` <!-- [id: 9] -->
- [DONE] Generate `bin/audit_k8s.sh` <!-- [id: 10] -->
- [DONE] Generate `bin/audit_maven.sh <!-- [id: 11] -->
- [DONE] Generate `bin/audit_security.sh` <!-- [id: 12] -->
- [DONE] Generate `bin/audit_sre.sh` <!-- [id: 13] -->
- [DONE] Generate `bin/audit_terraform.sh` <!-- [id: 14] -->
- [DONE] `chmod +x bin/audit_*.sh` <!-- [id: 15] -->

## Phase 3: Final Sync
- [DONE] Update `README.md` and `AGENTS.md` references <!-- [id: 16] -->
- [DONE] Update `conductor/product.md` vision <!-- [id: 17] -->
- [DONE] Verify all symlinks via `bin/nexus.py` <!-- [id: 18] -->
