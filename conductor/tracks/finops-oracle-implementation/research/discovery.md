# Discovery Report: FinOps Oracle Implementation

## 1. Specification Analysis
**Source**: `projects/project-fin-sentinel/README.md`

### Core Requirements
- **Multi-Cloud Cost Ingestion**: Unified parsing for AWS CUR and GCP Billing BigQuery exports.
- **"Ghost" Resource Detection**: Automated identification of orphaned volumes, unattached IPs, and idle compute clusters.
- **Contract-Aware Optimization**: Logic to verify usage against EDP and Savings Plans.
- **Automated Decommissioning**: Generates Terraform PRs for identified waste.

### Technical Stack
- **Language**: Python 3.11+
- **Data Engine**: AWS Athena (for CUR)
- **AI Engine**: Gemini Pro (Vertex AI)
- **Cost Engine**: Infracost

---

## 2. Schema Mapping (AWS CUR via Athena)
To enable precise cost attribution and ghost detection, the following Athena fields are mandatory:

| Field Name | Purpose |
|---|---|
| `line_item_resource_id` | Unique identifier for resource mapping. |
| `line_item_usage_type` | Categorization of usage (e.g., `BoxUsage:t3.medium`). |
| `line_item_unblended_cost` | Raw cost for optimization calculations. |
| `product_product_name` | Service identification (AmazonEC2, AmazonRDS, etc.). |
| `resource_tags_user_cost_center` | **CRITICAL**: Mandatory for governance compliance. |
| `resource_tags_user_environment` | Mapping costs to specific environments (dev, prod). |

---

## 3. State Analysis (Terraform)
**Location**: `projects/cloud-boot-app/terraform/`

### Current Tagging Posture
- **Status**: **NON-COMPLIANT**
- **Findings**:
    - Resources in `modules/cloud_boot_app` only have `Name` and `Environment` tags.
    - `Cost-Center` tag is missing across all modules.
    - ASG tags propagate at launch, but lack financial metadata.

### Resource Inventory (Potential Ghost Targets)
- `aws_elb.cba_elb`: Load balancers without active traffic.
- `aws_launch_configuration.cba_app`: Legacy launch configs.
- `aws_autoscaling_group.cba_app`: Potential idle compute.

---

## 4. Integration Points

### Logic Placement
- **Path**: `projects/cloud-boot-app/bin/finops/`
- **Component**: `oracle.py` (Main Orchestrator)

### Conductor Interaction
- The implementation will use the `conductor/tracks/finops-oracle-implementation/` directory for:
    - `metadata.json`: Tracking optimization metrics.
    - `research/`: Storing Athena query results and Gemini analysis.

---

## 5. Next Steps (Recommendation for Architect)
1. **Tagging Remediation**: Update all Terraform modules to include a mandatory `var.cost_center` and apply it to all taggable resources.
2. **Athena Setup**: Provision the Athena Workgroup and S3 bucket for CUR ingestion via Crossplane.
3. **Python Bootstrap**: Initialize the `bin/finops/` directory with a basic CLI structure using `click` or `argparse`.
4. **Infracost Integration**: Add `infracost` to the CI/CD pipeline (`.github/workflows/`) to catch cost spikes before merge.
