# AWS Reference: Identity, Access & Governance

Following the AWS Well-Architected Framework: Security Pillar.

## 1. IAM Foundations
- **Principle of Least Privilege (PoLP)**: Use IAM Access Analyzer to identify unused permissions and move toward zero-standing privileges.
- **IAM Identity Center (SSO)**: The only approved way for human access. Federate with an IDP (Azure AD, Okta) and use Permission Sets.
- **Temporary Credentials**: Use IAM roles for EC2 (Instance Profiles), Lambda (Execution Roles), and EKS (IRSA). No hardcoded access keys.

## 2. Organization Guardrails
- **Service Control Policies (SCPs)**: Centralized control to restrict regions, deny resource deletion, and enforce "public access block" across all accounts.
- **Control Tower**: Automated landing zone setup with pre-configured guardrails and account factory.

## 3. Advanced Auth & Policies
- **Resource-Based Policies**: Using S3 bucket policies and KMS key policies for explicit cross-account access.
- **ABAC (Attribute-Based Access Control)**: Using tags (`team`, `environment`) to grant access dynamically via policy variables.
- **Permissions Boundaries**: Used to delegate IAM creation to developers while preventing privilege escalation.

## 4. Operational Protocols
- **Credential Rotation**: Mandatory 90-day rotation for any legacy access keys.
- **MFA Enforcement**: Required for all Identity Center users and mandatory for the root account.