# Technical Specification: Hardening & Intuition

## 1. Directory Standards
- **`bin/`**: All executable shell scripts and discovery audits. Must be force-added to git if ignored.
- **`docs/`**: Human-readable architecture and design documents.
- **`docs/archive/`**: Historical logs, dependency trees, and legacy reports.
- **`terraform/core/`**: Primary entry point for infrastructure execution; no orphaned `.tf` files in `terraform/` root.

## 2. Discovery Protocol
Every expert in `.agent/agents/` requires a corresponding `bin/audit_<expert>.sh` script. These scripts must:
- Be POSIX compliant.
- Output version information for core tools.
- List available subcommands/flags for domain-specific CLI tools.
- Be idempotent and read-only.

## 3. Reference Integrity
Manifests (`AGENTS.md`, `README.md`) must point to the new `docs/` and `bin/` paths to ensure seamless navigation for both humans and agents.
