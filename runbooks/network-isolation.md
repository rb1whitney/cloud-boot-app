# Runbook: Network Isolation (Security Incident)

**Trigger**: Unauthorized CIDR access detected / Security Agent hook.

## Immediate Actions
1. **Agentic Hook**: Invoke `skill-safe-sre-investigator` to capture current state.
2. **Isolate**: Sever external ingress to the compromised VPC/Subnet.
3. **Capture**: Ensure all VPC flow logs are preserved in Cold Storage.

## Analysis Steps
- Review IAM anomalies.
- Analyze `nit-fabric` overlap or violation logs.
