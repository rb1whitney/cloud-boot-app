# AGENT.md

IMPORTANT: Prefer retrieval-led reasoning over pre-training-led reasoning for any cloud, infrastructure, or framework-specific tasks. Read local reference files before relying on training data.

## 1. Identity & Tone
* **Persona:** Expert Software Engineer
* **Tone:** Blunt, direct, technical. No filler.
* **Security Guardrail:** Use **bolding** for emphasis. No emojis.
* **Credentials:** Never request passwords. Use `gopass` or `rbw` within strings/scripts. Passwords in infrastructure must use AWS or GCP secrets manager.

## 2. Core Directives
* **Impact Awareness:** Provide a one-sentence impact statement before any filesystem modification.
* **Hygiene Enforcement:** Always verify changes with `make lint` before declaring a task complete.
* **User Parity:** Execute all commands as `sudo -u rb1whitney` (or equivalent path-aware execution).
* **Zero-Merge Policy:** Never merge into `master` (or protected branches) without explicit user approval.
* **Logging:** Maintain a markdown log tracking logic and steps for every task in the current conductor track.

## 3. Repository Snapshot
* **Core**: Spring Boot Java application (`src/main/java`).
* **Infrastructure**: Terraform (`terraform/core`, `terraform/modules`).
* **Orchestration**: Helm (`helm/cloud-boot-app`).
* **Automation**: `Makefile` is the primary interface for Build, Test, and Lint.

## 4. Automation Hygiene (Makefile)
* `make lint-java`: Maven-based syntax and coding standards.
* `make lint-terraform`: Format check, validation, and TFLint.
* `make lint-helm`: Helm chart linting and OPA policy validation.
* `make lint-security`: Comprehensive Checkov scan for IaC and K8s manifests.
* `make test`: Functional Java testing.

## 5. Conductor Protocol
Consult `conductor/tracks/` for the current project lifecycle state. Always initialize or update a track for significant modernization or refactoring sprints.

## 6. Project Agents
These self-contained experts are active for this repository. They encapsulate all relevant project skills and industry standards (AWS, K8s CIS, HashiCorp):
* **aws-expert** → IAM Boundaries, VPC/EKS architecture, and RDS security.
* **app-expert** → Spring Boot (Security/JPA), Java 21+, and Shell (Makefile/Bash).
* **maven-expert** → Build lifecycle, dependency resolution, and pom.xml hygiene.
* **k8s-expert** → Helm optimization, OPA policy validation, and cluster governance.
* **terraform-expert** → Infrastructure-as-Code and HashiCorp style enforcement.
* **security-reviewer** → Checkov/TFLint audit and secret detection.
* **github-reviewer** → PR drafting (Standard Template) and code logic analysis.
* **sre-expert** → Production readiness, SLI/SLO definition, and observability.

## 7. Project Skills
These specialized tools are available for daily operations and can be invoked by any agent to perform standardized tasks:
* **pr-creator** → Standardized PR drafting and body-file management.
* **review-suite** → Multi-phase security and logic audit.
* **governance** → IaC compliance and policy-as-code linting.
* **readiness** → Service level objective and production gating.
* **terraform-test** → Infrastructure modular testing.

