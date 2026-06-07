# Contributing to Cloud Boot App

First off, thank you for considering contributing to Cloud Boot App! It's people like you that make Cloud Boot App such a great tool.

## How Can I Contribute?

### Reporting Bugs

This section guides you through submitting a bug report for Cloud Boot App. Following these guidelines helps maintainers and the community understand your report, reproduce the behavior, and find related reports.

Before creating bug reports, please check if the issue has already been reported. When you are creating a bug report, please include as many details as possible. Fill out [the required template](.github/ISSUE_TEMPLATE/bug_report.md), the information it asks for helps us resolve issues faster.

### Suggesting Enhancements

This section guides you through submitting an enhancement suggestion for Cloud Boot App, including completely new features and minor improvements to existing functionality. Following these guidelines helps maintainers and the community understand your suggestion and find related suggestions.

Before creating enhancement suggestions, please check if the suggestion has already been made. When you are creating an enhancement suggestion, please include as many details as possible. Fill out [the template](.github/ISSUE_TEMPLATE/feature_request.md), including the steps that you imagine you would take if the feature were available.

### Pull Requests

*   Fill in the required template.
*   Follow the Java style guide (Google Java Style) and HCL standards.
*   Include tests for any new functionality (TDD-First).
*   Run `make lint` before submitting.
*   Ensure that any documentation is updated to reflect your changes.

## Styleguides

### Java Styleguide
We follow modern Java 21+ standards. All code should be formatted according to the project's `.editorconfig` or IDE standards.

### Terraform / HCL Styleguide
Follow the **Deterministic IaC Orchestration** guidelines:
*   Strong typing for all variables.
*   Mandatory descriptions for variables and outputs.
*   Snake_case naming conventions.

### Documentation Styleguide
*   Use Markdown for documentation.
*   Maintain the **Sovereign Hub** logic by updating relevant `AGENT.md` files in `.agent/` if specialists or skills change.
