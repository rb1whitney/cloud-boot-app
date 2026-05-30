# Implementation Plan: Terraform Modernization

This plan outlines the steps to resolve all identified linting issues in the Terraform codebase, ensuring compliance with `tflint` and project standards.

## Phase 1: Foundation & Versioning
**Goal:** Standardize Terraform and Provider version constraints.

- [~] Task: Update `terraform/core/main.tf` with `required_version` and provider constraints `[~]`
- [ ] Task: Standardize provider constraints in `terraform/module-groups/cloud-boot-app/versions.tf` `[ ]`
- [ ] Task: Standardize provider constraints in `bastion`, `cloud_boot_app`, `cloud_domain`, and `s3_bucket` modules `[ ]`

## Phase 2: Variable & Output Standards
**Goal:** Implement strong typing and documentation for all IaC parameters.

- [ ] Task: Add types and descriptions to all variables in `terraform/module-groups/cloud-boot-app/variable.tf` `[ ]`
- [ ] Task: Add types and descriptions to variables in `terraform/modules/s3_bucket` and other modules `[ ]`
- [ ] Task: Add descriptions to all outputs in `bastion`, `cloud_boot_app`, and `cloud_domain` modules `[ ]`
- [ ] Task: Fix naming convention for `Cloud-Boot-App-Output` (convert to `snake_case`) `[ ]`

## Phase 3: Syntax & Technical Debt Cleanup
**Goal:** Remove unused code and modernize access syntax.

- [ ] Task: Convert list index access to square brackets in `cloud_domain` module `[ ]`
- [ ] Task: Remove unused `aws_availability_zones` data source in `cloud_boot_app` `[ ]`
- [ ] Task: Run `terraform fmt -recursive` to standardize formatting `[ ]`

## Phase 4: Final Validation
**Goal:** Confirm 100% compliance with linting rules.

- [x] Task: Run `make lint-hcl` and verify 0 issues found `[x]` 1532d63
- [x] Task: Conductor - User Manual Verification 'Terraform Modernization' (Protocol in workflow.md) `[x]`
