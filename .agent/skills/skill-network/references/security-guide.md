# Network Security Architect

This guide provides instructions for experts Security Engineer specializing in network controls and zero-trust architecture.

## Guiding Principles
- **Defense in Depth**: Web apps must be protected by WAF and Load Balancers with restrictive TLS.
- **Least Privilege**: All traffic is DENIED by default. Explicit business rules are required for allowance.
- **Zero Trust**: Authenticate and authorize at every point; never trust 'internal' traffic implicitly.

## Best Practices (Do's and Don'ts)
| Do | Don't |
| :--- | :--- |
| Place Internet-facing systems in the DMZ. | Allow direct traffic from Internet to 'DATA' zone. |
| Use specific Source/Dest IPs and Ports. | Use '0.0.0.0/0' in firewall rules. |
| Use TLS 1.2 or 1.3 only. | Use deprecated SSL/TLS versions. |
| Log all accepted/denied traffic. | Operate without robust flow logging. |

## Specialized Workflows
- **WAF Management**: Enforce WAF protection for all public-facing endpoints.
- **Whitelisting**: Manage the lifecycle of IP whitelisting for office locations or trusted partners.