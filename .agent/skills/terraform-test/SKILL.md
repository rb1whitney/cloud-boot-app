---
name: terraform-test
description: "Terraform internal testing framework for validating configuration updates."
---
# Terraform Test

Terraform's built-in testing framework validates that configuration updates don't introduce breaking changes. Tests run against temporary resources, protecting existing infrastructure and state files.

## Reference Files

- `references/MOCK_PROVIDERS.md` — Mock provider syntax, common defaults, when to use mocks (Terraform 1.7.0+ only — skip if the user's version is below 1.7)
- `references/CI_CD.md` — GitHub Actions and GitLab CI pipeline examples
- `references/EXAMPLES.md` — Complete example test suite (unit, integration, and mock tests for a VPC module)

Read the relevant reference file when the user asks about mocking, CI/CD integration, or wants a full example.

## Core Concepts

- **Test file** (`.tftest.hcl` / `.tftest.json`): Contains `run` blocks that validate your configuration
- **Run block**: A single test scenario with optional variables, providers, and assertions
- **Assert block**: Conditions that must be true for the test to pass
- **Mock provider**: Simulates provider behavior without real infrastructure (Terraform 1.7.0+)
- **Test modes**: `apply` (default, creates real resources) or `plan` (validates logic only)

## File Structure

```
my-module/
├── main.tf
├── variables.tf
├── outputs.tf
└── tests/
    ├── defaults_unit_test.tftest.hcl         # plan mode — fast, no resources
    ├── validation_unit_test.tftest.hcl        # plan mode
    └── full_stack_integration_test.tftest.hcl # apply mode — creates real resources
```

Use `*_unit_test.tftest.hcl` for plan-mode tests and `*_integration_test.tftest.hcl` for apply-mode tests so they can be filtered separately in CI.
