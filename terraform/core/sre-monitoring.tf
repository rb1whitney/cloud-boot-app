terraform {
  required_version = ">= 1.5.0"
}

# SRE Golden Signals - Production Resources
# This defines the physical infrastructure for observability logs.

resource "aws_cloudwatch_log_group" "sre_signals" {
  name              = "/aws/sre/${local.service_name}-golden-signals"
  retention_in_days = 30

  tags = {
    Environment = "production"
    Application = "cloud-boot-app"
    ManagedBy   = "AgenticSRE"
  }
}

locals {
  service_name = "cloud-boot-app"
}

# Required Golden Signals (SLIs):
# 1. Latency: aws_cloudwatch_log_metric_filter (Placeholder)
# 2. Traffic: LB Request Count
# 3. Errors: HTTP 5XX Count
# 4. Saturation: CPU/Memory Utilization

output "sre_golden_signals_log_group" {
  value       = aws_cloudwatch_log_group.sre_signals.name
  description = "The CloudWatch Log Group where golden signal logs are aggregated."
}

output "sre_golden_signals_status" {
  value       = "SRE Golden Signals resources initialized for ${local.service_name}"
  description = "Status message confirming SRE infrastructure deployment."
}
