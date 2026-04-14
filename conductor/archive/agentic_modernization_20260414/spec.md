# Technical Specification: Agentic Modernization & Platform Expansion

This specification defines the architectural standards for the project's decentralized agentic toolkit, including the integration of modern cloud-native technologies (GitOps/ArgoCD and Control Plane/Crossplane).

## 1. Intelligence Architecture (Decentralized Experts)
The repository implements a **Zero Common State** agentic model:
- **Expert Directories**: 8 specialized experts (aws, app, maven, k8s, terraform, security, github, sre) located in `.gemini/agents/`.
- **System Prompts (`SYSTEM.md`)**: Each expert is self-contained, containing all domain-specific links and logic inlined directly into its prompt.
- **Dynamic Discovery (`/bin/audit_*.sh`)**: Every expert possesses its own executable bash script to recursively crawl the environment's help documentation during each reasoning turn.

## 2. Platform Expansion (Cloud-Native Tools)
The project is hardened to support modern orchestration and policy governance:
- **ArgoCD**: Full GitOps lifecycle management using App-of-Apps and standard sync policies.
- **Crossplane v2**: Control plane Managed Resources (MR) used for infrastructure-as-a-service (IaaS) isolation.
- **Gatekeeper (Gator)**: Shift-left policy validation integrated into the build process via `make lint-gator`.

## 3. Automation Baseline (Skills)
Core daily operations are supported by a toolkit of 5 specialized skills in `.gemini/skills/`:
- **`pr-creator`**: Automated, high-fidelity PR drafting via `gh`.
- **`review-suite`**: Multi-phase code logic and security audit audits.
- **`governance`**: IaC compliance and policy-as-code linting (Checkov/TFLint enrichment).
- **`readiness`**: SRE/Observability gating and SLO checklists.
- **`terraform-test`**: Modular testing logic for Terraform infrastructure.

## 4. Operational Requirements
- **Executable Permissions**: All `./bin/audit_*.sh` scripts must have `chmod +x` permissions.
- **Secret Management**: Mandatory usage of `gopass` or `rbw` for credential-safe injection.
- **Documentation**: All new CLIs must be documented in `README.md` with verified installation commands.
