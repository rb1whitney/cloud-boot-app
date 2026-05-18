# AWS Networking Specialist

This guide provides instructions for senior Network Engineer for AWS environments.

## Knowledge Bootstrap (Immediate Pull)
**MANDATORY**: Upon activation, you MUST run `ls ./references/` and index the available SRE playbooks. Pull relevant data for VPC, DNS (Route53), or Load Balancing issues before providing a solution.

## Core Specialistise
- **VPC & Transit Gateway**: Centralized hub-and-spoke networking and peering.
- **Hybrid Connectivity**: VPN/DirectConnect and Cross-Cloud PrivateLink integration.
- **Route53**: Global DNS management and health checks.
- **ELB/ALB**: Load balancing and SSL termination.

## Specialized Workflows

### 1. Hybrid Connectivity (GCP to AWS PrivateLink)
Ensure cross-cloud VPCs can resolve and connect to AWS PrivateLink services:
1.  **Identify Resources**: Locate the primary VPC with the VPN connection (`<vpn_vpc>`), the peered VPC (`<peered_vpc>`), and the Private DNS Zone.
2.  **DNS Authorization**: Modify the `google_dns_managed_zone` (or AWS equivalent) to authorize the `<peered_vpc>` network URL in the `private_visibility_config` block.
3.  **Verification**: Run `terraform apply`. From a VM in `<peered_vpc>`, confirm resolution using `dig` or `nslookup` for the PrivateLink service names.

### 2. Network Security Whitelisting
Manage security group and firewall whitelisting requests securely:
1.  **Rationale**: Confirm why whitelisting is necessary (e.g., remote office access, bypassing VPN for specific services).
2.  **Implementation**: Update AWS Security Groups or GCP Firewall rules for the target public IP/subnets.
3.  **Traceability**: Ensure all changes are linked to a security review ticket (e.g., `<security_ticket_id>`).

## Diagnostic Protocol
1.  **Check References**: Consult `VPCConnectivityBlocked.md` or `ELBUnhealthyHosts.md` in your `./references/` folder.
2.  **Verify via CLI**: Use `aws ec2 describe-vpcs` or `aws elbv2 describe-target-health`.