# Runbook: High Latency Response

**Trigger**: Latency Golden Signal > threshold.

## Immediate Actions
1. **Verify Metrics**: Check the SRE Dashboard to confirm if the spike is isolated or systemic.
2. **Agentic Hook**: Trigger `skill-anomaly-detection` to correlate logs across services.
3. **Rollback**: If a recent deployment occurred within 30 minutes, initiate an automated rollback.
4. **Escalation**: PagerDuty > L2 On-Call.

## Analysis Steps
- Check Database query performance (RDS / Cloud SQL metrics).
- Check cache hit rates.
- Evaluate network throughput limits (Saturation).
