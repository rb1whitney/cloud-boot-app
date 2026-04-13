# Implementation Plan: CI/CD & IaC Modernization

## 1. Local Tooling & Reproducibility
- [ ] Update `devbox.json` to include `tflint`, `checkov`, `conftest` (for OPA), and `hadolint` (for Docker).
- [ ] Create a root `Makefile` in `cloud-boot-app/` to orchestrate local linting.

## 2. Infrastructure as Code (IaC) Testing
- [ ] Implement `terraform fmt -check` and `terraform validate` across all modules.
- [ ] Integrate `tflint` with AWS-specific rules.
- [ ] Add `checkov` for static security analysis of Terraform and Helm charts.

## 3. GitHub Actions Refactor
- [ ] Modernize `.github/workflows/lint.yml` to use a matrix strategy or unified jobs for:
    - Java (Maven/Checkstyle)
    - Terraform (fmt, validate, tflint, checkov)
    - Kubernetes (Helm lint, kube-linter)
    - OPA (conftest)
    - Docker (hadolint)

## 4. Policy & Helm Validation
- [ ] Add `conftest` checks for the Gatekeeper policies in `gatekeeper/`.
- [ ] Ensure Helm chart passes `helm lint`.

## 5. Verification
- [ ] Run `make lint` locally and fix all reported issues.
- [ ] Trigger GitHub Action and verify all stages pass.
