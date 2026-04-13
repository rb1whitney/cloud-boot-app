# Tech Stack

## Languages & Runtimes

| Language | Version | Purpose |
|---|---|---|
| Java | 21 (LTS) | Backend application logic (Spring Boot 3.2) |
| Python | 3.11+ | AST bridge tools, automation scripts, code_mapper.py |
| Bash / Shell | POSIX | CI scripts, provisioning helpers, bin/ utilities |
| HCL | Terraform 1.7+ | Infrastructure as code for AWS, GCP, Azure |
| YAML | ansible-core 2.15+ | Configuration management and provisioning |
| Markdown | GitHub Flavored | Documentation, skill definitions, AGENT.md |
| JSON | standard | Relationship graph, AST cache, API payloads |

## Frameworks & Build Tools

| Tool | Version | Role |
|---|---|---|
| Spring Boot | 3.2.x | Primary backend framework |
| Maven | 3.9+ | Java build and dependency management |
| JUnit | 5.x | Unit and integration testing |
| Project Lombok | latest | Java boilerplate reduction |
| SpringDoc OpenAPI | 2.3+ | API documentation (Swagger UI) |

## AI Tooling

| Tool | Version | Role |
|---|---|---|
| Gemini CLI | latest | Primary agent interface, skill runner |
| Claude Code | latest | Pair programming, code review |
| GitHub Copilot | latest | IDE autocomplete and inline suggestions |
| Gemini 1.5 Flash | API | Fast agentic synthesis for code map summaries |
| Gemini 2.5 Pro | API | Deep reasoning for architecture and planning |

## Cloud Platforms

| Platform | Approved Services |
|---|---|
| AWS | EC2, EKS, RDS, Aurora, DynamoDB, Lambda, SQS, SNS, S3, IAM, KMS, VPC, Route53, ALB, CloudFront, ECR, ECS, CloudWatch |
| GCP | GKE, Cloud SQL, Cloud Run, Cloud Storage, IAM, Secret Manager, Artifact Registry, Pub/Sub, Cloud Functions |
| Azure | AKS, Azure VM, Azure SQL, Blob Storage, Azure AD, Key Vault (via terraform-azure-verified-modules) |

## Infrastructure as Code

| Tool | Version | Purpose |
|---|---|---|
| Terraform | managed via tfenv | Primary IaC — all cloud resources |
| tfenv | latest | Terraform version management across projects |
| Packer | 1.10+ | Immutable AMI and VM image builds |
| Ansible | core 2.15+ | Configuration management, OS provisioning |
| Helm | 3.x | Kubernetes workload packaging and deployment |

## Container & Orchestration

| Tool | Version | Purpose |
|---|---|---|
| Podman / Docker | 5+ / 24+ | Local image builds and testing |
| Google Distroless | Java 21 | Secure, minimal runtime container image |
| kubectl | 1.29+ | Kubernetes cluster interaction |
| Helm | 3.x | Chart management |

## CI / CD

| Tool | Purpose |
|---|---|
| GitHub Actions | Lint, validate, test on every PR |
| Jenkins | Automated deployment pipeline (containerized) |
| tflint | Terraform static analysis with AWS ruleset |
| terraform fmt | HCL formatting enforcement |
| terraform validate | Configuration correctness |
| ansible-lint | Ansible playbook quality with production profile |

## Developer Tooling

| Tool | Purpose |
|---|---|
| Homebrew | Package management on macOS and Linux |
| GitHub CLI (gh) | PR creation, issue management, repo operations |
| jq | JSON processing in shell scripts |
| tree-sitter 0.20.1 | AST parsing for code_mapper.py (pinned) |

## Conventions

- **Terraform naming**: `snake_case` for all resource names, variables, outputs
- **Terraform variables**: All variables must have `description` and `type`
- **Ansible tasks**: All tasks must have `name`; use `become` explicitly
- **Python**: Targeting 3.11+; no external dependencies beyond requirements in each tool dir
- **Secrets**: Never committed — use AWS Secrets Manager, GCP Secret Manager, or Ansible Vault
- **State**: Terraform state must be remote (S3 + DynamoDB lock or GCS) — local state is never committed

## Approved vs Not Approved

| Approved | Not Approved |
|---|---|
| Java 21 / Spring Boot 3.2 | Java 1.8 / Spring Boot 1.x |
| Maven 3.9+ | Gradle (for this project) |
| Google Distroless | Ubuntu/Alpine full OS images |
| Terraform for all cloud resources | CloudFormation, CDK |
| Ansible for OS config | Chef, Puppet |
| Gemini Flash for agentic synthesis | GPT-4 (no org license) |
| GitHub Actions / Jenkins | CircleCI |
| Helm for K8s workloads | Raw kubectl apply in CI |
