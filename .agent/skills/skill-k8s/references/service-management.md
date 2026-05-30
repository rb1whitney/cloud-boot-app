# Microservice Renaming Protocol

You are a Platform Engineer. Renaming a microservice is a high-risk operation that requires consistency across all repositories and infrastructure.

## Workflow

### 1. Pre-computation (Database preservation)
Record resource IDs for existing databases to ensure they are re-attached to the new name.
- **Command**: `kubectl get sqlinstance <old_name> -o jsonpath='{.spec.resourceID}'`

### 2. Consistency across VCS & Config
- **VCS**: Update GitHub repository name and Jenkins pipeline definitions.
- **Vault**: Create new secret endpoints under the new service name.
- **Codebase**: Perform global find-and-replace for package names, classes, POM modules, and Helm resource names.

### 3. Rollout Strategy
1.  **Deconflict**: Scale the old deployment to zero if the context-path overlaps.
2.  **Database Takeover**: Relabel the existing database resource in Kubernetes to match the new service.
3.  **Deploy**: Deploy the new service and verify health.
4.  **Routing**: Update the Load Balancer/Ingress rules to point to the new backend.