# Specification: CI/CD & IaC Modernization

## 1. Objective
Modernize the GitHub Actions workflows to provide comprehensive linting and security scanning across Java, Terraform, Helm, and OPA policies. Ensure parity between local development and CI by providing a unified local linting experience.

## 2. Scope
- **GitHub Actions**: Refactor `lint.yml` to include multi-language support.
- **Local Tooling**: Integrate linters into `devbox.json` and a root `Makefile` for "sanity check" execution.
- **IaC Testing**: Implement `terraform validate`, `tflint`, and security scanning (e.g., `checkov`) for all infrastructure modules.
- **Policy Testing**: Add linting/testing for OPA Gatekeeper policies.

## 3. Success Criteria
- [x] Unified GitHub Action running linting for Java, HCL, YAML, and Rego.
- [x] Root `Makefile` allowing `make lint` to run all checks locally.
- [x] Infrastructure modules pass `tflint` and basic security benchmarks.
- [x] OPA policies pass basic syntax and logic validation.
