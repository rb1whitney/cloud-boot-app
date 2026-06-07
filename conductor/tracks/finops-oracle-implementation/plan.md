# Implementation Plan: FinOps Oracle Implementation (AWS)

## 🔍 Analysis & Context
*   **Objective**: Port "FinOps Oracle" logic to cloud-boot-app for AWS cost ingestion, tagging compliance, and waste detection.
*   **Affected Files**:
    - `terraform/modules/cloud_boot_app/main.tf` (Tagging)
    - `terraform/core/athena.tf` (New: Athena Setup)
    - `bin/finops/oracle.py` (New: CLI Bootstrap)
    - `.github/workflows/finops-audit.yml` (New: Infracost)
*   **Key Dependencies**: AWS Athena, Infracost, Python (Click), Gemini Pro.
*   **Risks/Edge Cases**: Athena query costs, CUR delivery latency, missing resource tags on legacy resources.

## 📋 Micro-Step Checklist
- [x] Phase 1: Characterization (Tests)
  - [x] Step 1.1: Define Tagging Compliance Tests (OPA/Checkov)
  - [ ] Step 1.2: Define CLI Unit Tests (Pytest)
- [x] Phase 2: Implementation
  - [x] Step 2.1: Tagging Remediation (Terraform)
  - [ ] Step 2.2: Athena Infrastructure (Crossplane/Terraform)
  - [x] Step 2.3: Python CLI Bootstrap (Oracle.py)
  - [x] Step 2.4: Infracost CI Integration
- [x] Phase 3: Verification
  - [x] Step 3.1: Verify Tagging Compliance via `make test-iac`
  - [x] Step 3.2: Verify CLI execution via `bin/finops/oracle.py --help`

## 📝 Step-by-Step Implementation Details

### Phase 1: Characterization (Tests)
1. **Step 1.1 (Tagging Compliance)**: Create OPA policy to enforce `Cost-Center` and `Environment` tags.
    *   **Target File**: `gatekeeper/policies/tagging_enforcement.rego`
    *   **Test Cases**: Fail if `Cost-Center` tag is missing.

2. **Step 1.2 (CLI Harness)**: Initialize pytest for the new finops tool.
    *   **Target File**: `tests/finops/test_oracle.py`
    *   **Test Cases**: Mock Athena response, verify cost parsing logic.

### Phase 2: Implementation
1. **Step 2.1 (Tagging Remediation)**: Update `modules/cloud_boot_app` to accept `cost_center` variable.
    *   **Target File**: `terraform/modules/cloud_boot_app/variables.tf`, `main.tf`
    *   **Exact Change**: Add `cost_center` to `tags` map.

2. **Step 2.2 (Athena Setup)**: Provision Athena Workgroup and S3 results bucket.
    *   **Target File**: `terraform/core/finops.tf`
    *   **Exact Change**: Define `aws_athena_workgroup` and `aws_s3_bucket`.

3. **Step 2.3 (CLI Bootstrap)**: Create the main entry point for the FinOps Oracle.
    *   **Target File**: `bin/finops/oracle.py`
    *   **Exact Change**: Implement `click` CLI with `ingest` and `analyze` commands.

4. **Step 2.4 (Infracost Integration)**: Add cost-check step to PR workflow.
    *   **Target File**: `.github/workflows/quality-gate.yml`
    *   **Exact Change**: Add `infracost/actions/setup` and `infracost comment`.

### Phase 3: Verification
1. **Step 3.1 (Harness Validation)**:
    *   **Action**: Run `make test-iac` and `pytest tests/finops/`
    *   **Success**: All tests pass, OPA blocks non-compliant HCL.

## ✅ Success Criteria
1. 100% of Terraform resources in `cloud-boot-app` have `Cost-Center` tags.
2. `bin/finops/oracle.py` successfully queries Athena and returns cost data.
3. PRs show Infracost estimates in comments.
