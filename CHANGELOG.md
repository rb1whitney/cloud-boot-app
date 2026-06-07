# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Standardized project documentation: `LICENSE`, `CONTRIBUTING.md`, `SUPPORT.md`, and `CHANGELOG.md`.
- Refactored `AGENTS.md` to `AGENT.md` following the Unified Agentic Standard.

## [1.2.0] - 2026-05-30
### Added
- Migration to Spring Boot 4.0.6 and Spring Framework 7.0.7.
- Java 21+ modernization.
- Springdoc 3.0.3 integration with MCP support.
- SSRF prevention and alphanumeric sanitization for security endpoints.
- Consolidated integration test suite using `@MockitoBean`.

## [1.1.0] - 2026-04-14
### Added
- **Agentic Hub Standardization (ACS-2026)**: Centralized all specialists and skills in `.agent/`.
- Tiered Context Gating for 60-98% token reduction.
- Nexus Sync Engine (`bin/nexus.py`) for deterministic platform parity.
- ArgoCD GitOps lifecycle management.
- Gatekeeper (Gator) OPA policy validation.

## [1.0.1] - 2026-04-12
### Fixed
- **Deterministic IaC Orchestration**: Standardized HCL syntax across `terraform/`.
- Enforced strong typing and descriptions for all variables and outputs.
- Eradicated deprecated Terraform syntax (element access, dotted index).
- Integrated TFLint and Checkov into `make lint` pipeline.

## [1.0.0] - 2026-01-15
### Added
- **Zero-Trust Hardening**: RDS/S3 encryption at rest and IAM least privilege.
- DTO decoupling for persistence layer.
- Distroless container strategy to reduce attack surface.
- Initial OPA Gatekeeper policy enforcement.
- Baseline Spring Boot application with Terraform infrastructure.
