# Roadmap: Agentic Modernization & Platform Expansion

This roadmap outlines the long-term goal of transforming the `cloud-boot-app` into a fully autonomous, policy-driven cloud platform.

## Current Goal
- **Decentralized Hardening**: Transition to 8 Portable experts and a restored core skill toolkit. (COMPLETED)

## Future Tracks & Milestones

### ⏹️ Track: Lifecycle Automation (Phase 2)
- **Goal**: Implement full CI/CD automation using the newly restored `pr-creator` and `review-suite` skills.
- **Milestones**:
    - Automate the `make lint-gator` gate as a mandatory pull-request check.
    - Standardize PR body-file generation for all automated commits.

### ⏹️ Track: Crossplane-Driven IaaS (Phase 3)
- **Goal**: Transition from standalone Terraform to a Crossplane-driven Control Plane model for all managed infrastructure.
- **Milestones**:
    - Build a Composite Resource (XR) for the Cloud Boot App's RDS database.
    - Implement drift detection and automated remediation via Crossplane.

### ⏹️ Track: GitOps Mastery (Phase 4)
- **Goal**: 100% GitOps lifecycle for application and policy deployments.
- **Milestones**:
    - Transition Gatekeeper policy applications to ArgoCD.
    - Implement automated blue/green delivery using Argo Rollouts.
