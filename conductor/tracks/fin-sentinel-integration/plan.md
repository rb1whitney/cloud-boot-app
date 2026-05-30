# Implementation Plan: Financial Sentinel Integration
## 🔍 Analysis & Context
*   **Objective**: Port Fin-Sentinel governance and monitoring standards to cloud-boot-app.
*   **Affected Files**:
    - `terraform/core/sre-monitoring.tf`
    - `gatekeeper/constraints/regional-sovereignty.yaml`
    - `gatekeeper/templates/regional-egress.yaml`
*   **Key Dependencies**: AWS CloudWatch, OPA Gatekeeper, Terraform.
*   **Risks/Edge Cases**:
    - CloudWatch metric filter pattern mismatch.
    - OPA policy blocking legitimate cross-region traffic if not scoped correctly.

## 📋 Micro-Step Checklist
- [x] Phase 1: Characterization (TDD)
  - [x] Step 1.1: Create Terraform validation tests for CloudWatch filters.
  - [x] Step 1.2: Create OPA policy unit tests (Rego).
- [x] Phase 2: Monitoring Implementation
  - [x] Step 2.1: Implement Golden Signal metric filters in `sre-monitoring.tf`.
  - [x] Step 2.2: Implement CloudWatch Alarms for Latency and Errors.
- [x] Phase 3: Governance Implementation
  - [x] Step 3.1: Define OPA Rego template for regional egress control.
  - [x] Step 3.2: Apply Gatekeeper constraints for data residency.
- [x] Phase 4: Automation & Verification
  - [x] Step 4.1: Link Alarms to SNS topics for Agentic Hooks.
  - [x] Step 4.2: End-to-end verification of policy enforcement.

## 📝 Step-by-Step Implementation Details

### Phase 1: Characterization (TDD)
1. **Step 1.1 (Terraform Validation)**: Define expected resource counts and attributes.
    *   **Target File**: `tests/terraform/monitoring_test.go` (or similar check)
    *   **Test Cases**: Verify 4 metric filters exist (Latency, Traffic, Errors, Saturation).
2. **Step 1.2 (OPA Unit Tests)**: Write Rego tests for regional sovereignty.
    *   **Target File**: `gatekeeper/tests/regional_sovereignty_test.rego`
    *   **Test Cases**: Deny egress to unauthorized regions; Allow egress to `us-east-1`.

### Phase 2: Monitoring Implementation
1. **Step 2.1 (Golden Signals)**: Update `terraform/core/sre-monitoring.tf`.
    *   **Target File**: `projects/cloud-boot-app/terraform/core/sre-monitoring.tf`
    *   **Exact Change**: Replace placeholders with `aws_cloudwatch_log_metric_filter` for `[ERROR]`, `latency`, etc.

### Phase 3: Governance Implementation
1. **Step 3.1 (OPA Policies)**: Create regional constraints.
    *   **Target File**: `projects/cloud-boot-app/gatekeeper/constraints/regional-sovereignty.yaml`
    *   **Exact Change**: Define `Constraint` targeting `Service` and `Deployment` egress.

### Phase 4: Verification
1. **Step 4.1 (Harness Validation)**:
    *   **Action**: Run `terraform plan` and `opa test .`
    *   **Success**: No policy violations in tests; Terraform plan shows 8+ new resources.

## ✅ Success Criteria
1. CloudWatch Alarms trigger on 5% error rate or >500ms latency.
2. OPA Gatekeeper blocks any deployment targeting non-approved AWS regions.
3. Agentic Hooks (`skill-anomaly-detection`) receive alert payloads.
