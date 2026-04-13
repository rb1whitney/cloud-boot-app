# Cloud Boot Application
[![Status](https://travis-ci.org/rb1whitney/cloud-boot-app.svg?branch=master)](https://travis-ci.org/rb1whitney/cloud-boot-app)

This is a modernized Java Maven Spring Boot 3.2 application designed for cloud-native deployment. It utilizes Java 21 and features a containerized architecture using Google Distroless for enhanced security and minimal image size.

## Modernization Highlights
- **Framework:** Spring Boot 3.2.11
- **Runtime:** Java 21 (Eclipse Temurin)
- **Container:** Google Distroless Java 21 (Debian 12)
- **Architecture:** Clean N-Tier (Controller -> Service -> Repository)
- **Security:** OPA Gatekeeper policies for cluster-level enforcement.
- **Infrastructure:** Multi-layered approach using Terraform and Crossplane v2.

### Playing with the REST Service

#### System Endpoints:
```bash
# Hello World
curl http://localhost:8090/cloud-boot-app/

# Version Info
curl http://localhost:8090/cloud-boot-app/version

# Swagger UI
http://localhost:8090/cloud-boot-app/swagger-ui/index.html
```

#### CRUD Operations:
```bash
# Create data object
curl -H "Content-Type: application/json" -X POST -d '{ "name" : "Test Data", "description" : "This is a sample description" }' http://localhost:8090/cloud-boot-app/api/v1/data

# Read all data objects
curl -H "Content-Type: application/json" -X GET http://localhost:8090/cloud-boot-app/api/v1/data
```

## Prerequisites & Tooling

To run the full suite of local linters and tests, the following tools are required:
- **Java 21** & **Maven 3.9+**
- **Terraform 1.5+**
- **Helm 3.14+**
- **TFLint** (with AWS plugin)
- **Checkov** (Static security analysis)
- **Conftest** (OPA policy validation)
- **Hadolint** (Dockerfile linting)

*Tip: Use **Devbox** (`devbox shell`) to automatically install all these tools via Nix.*

### Local Quality Checks (Sanity Check)
Run the following commands before committing to ensure code quality and security:

```bash
# Run all linters AND logic tests (Java, HCL, Helm, Rego Unit Tests)
make lint

# Run infrastructure logic tests & security scans (Checkov)
make test-iac

# Run Java unit tests with coverage
make test-java
```

### Advanced Infrastructure Testing
This project implements modern "IaC as Code" testing patterns:
- **OPA Unit Testing**: Logic for Gatekeeper policies is verified via `opa test` in `gatekeeper/tests/`.
- **Terraform Logic Tests**: Behavioral assertions for infrastructure are defined in `.tftest.hcl` files.
- **Static Security Analysis**: `checkov` scans all Terraform and Helm manifests for 2026 security benchmarks.
- **Helm Integration Tests**: Deployment-time connection tests are included in the chart.

## Running the Project

### Local Development (Devbox & Nix)
This project uses **Devbox** for a reproducible development environment.

```bash
# Enter the dev environment (installs Java, Maven, Terraform, Helm, etc.)
devbox shell

# Run local build
mvn clean package
```

### On-Demand Kubernetes Development (Skaffold)
Use **Skaffold** for rapid, iterative testing in a Kubernetes namespace.

```bash
# Start dev loop in an on-demand namespace
skaffold dev -n my-dev-namespace
```

### GitOps Deployment (Argo CD)
Apply the Argo CD application to sync the entire project via GitOps:

```bash
# Apply the Argo CD Apps
kubectl apply -f argocd/application.yaml
```

## Infrastructure & CI/CD
- **Terraform:** Located in `terraform/` for AWS deployment.
- **Helm:** Located in `helm/cloud-boot-app` for Kubernetes deployments.
- **Crossplane:** v2 Composite Resources for managed infrastructure.
- **Argo CD:** GitOps manifests for automated syncing.
- **Skaffold:** For local Kubernetes development workflow.
- **Devbox:** Nix-powered reproducible dev environment.
- **Gatekeeper:** OPA policies for cluster security.

### Applying Security Policies (Gatekeeper)
```bash
# Apply Constraint Templates
kubectl apply -f gatekeeper/templates/

# Apply Constraints
kubectl apply -f gatekeeper/constraints/
```

## License
Modified and used from [khoubyari/spring-boot-rest-example](https://github.com/khoubyari/spring-boot-rest-example).
