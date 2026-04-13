# Specification: IaC Modernization (Terraform Lint Remediation)

## Overview
This track addresses a backlog of 32+ Terraform linting issues identified by `tflint`. The goal is to bring the infrastructure-as-code into compliance with modern standards, including explicit versioning, strong typing for variables, and complete documentation for outputs.

## Scope
### 1. Versioning Standards
- Define `required_version` for Terraform in `terraform/core`.
- Add explicit version constraints for the `aws` and `template` providers in all modules and module groups.

### 2. Variables & Outputs (Strong Typing & Documentation)
- Add `type` attributes to all variable definitions.
- Add `description` attributes to all variables and outputs.
- Rename `Cloud-Boot-App-Output` to `cloud_boot_app_output` to adhere to `snake_case` naming conventions.

### 3. Syntax & Technical Debt
- Replace deprecated `element()` or dotted index access with modern square bracket `[]` syntax for lists.
- Remove unused data sources (e.g., `aws_availability_zones` in `cloud_boot_app`).

## Success Criteria
- `make lint-hcl` (or `tflint`) passes with 0 warnings or notices.
- All variables have explicit types and descriptions.
- All outputs have descriptions.
- No deprecated syntax remains in the `terraform/` directory.

## Out of Scope
- Modifying actual cloud resource configurations (logic changes).
- Changing backend state configuration.
- Updating Terraform versions beyond standardizing existing constraints.
