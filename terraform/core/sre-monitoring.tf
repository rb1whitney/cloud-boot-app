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

resource "aws_cloudwatch_log_metric_filter" "latency" {
  name           = "Latency"
  pattern        = "[..., latency, status_code=200, ...]"
  log_group_name = aws_cloudwatch_log_group.sre_signals.name

  metric_transformation {
    name      = "ResponseLatency"
    namespace = "SRE/GoldenSignals"
    value     = "$latency"
  }
}

resource "aws_cloudwatch_log_metric_filter" "traffic" {
  name           = "Traffic"
  pattern        = "" # Match all requests
  log_group_name = aws_cloudwatch_log_group.sre_signals.name

  metric_transformation {
    name      = "RequestCount"
    namespace = "SRE/GoldenSignals"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "errors" {
  name           = "Errors"
  pattern        = "[..., status_code=5*, ...]"
  log_group_name = aws_cloudwatch_log_group.sre_signals.name

  metric_transformation {
    name      = "ErrorCount"
    namespace = "SRE/GoldenSignals"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "saturation" {
  name           = "Saturation"
  pattern        = "[..., cpu_utilization, memory_utilization, ...]"
  log_group_name = aws_cloudwatch_log_group.sre_signals.name

  metric_transformation {
    name      = "ResourceSaturation"
    namespace = "SRE/GoldenSignals"
    value     = "$cpu_utilization"
  }
}

# CloudWatch Alarms
resource "aws_cloudwatch_metric_alarm" "high_latency" {
  alarm_name          = "HighLatency"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "ResponseLatency"
  namespace           = "SRE/GoldenSignals"
  period              = "60"
  statistic           = "Average"
  threshold           = "500"
  alarm_description   = "This metric monitors response latency"
  alarm_actions       = [aws_sns_topic.sre_alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "high_error_rate" {
  alarm_name          = "HighErrorRate"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "ErrorCount"
  namespace           = "SRE/GoldenSignals"
  period              = "60"
  statistic           = "Sum"
  threshold           = "5"
  alarm_description   = "This metric monitors error count"
  alarm_actions       = [aws_sns_topic.sre_alerts.arn]
}

resource "aws_sns_topic" "sre_alerts" {
  name = "sre-alerts-topic"
}

output "sre_golden_signals_log_group" {
  value       = aws_cloudwatch_log_group.sre_signals.name
  description = "The CloudWatch Log Group where golden signal logs are aggregated."
}

output "sre_golden_signals_status" {
  value       = "SRE Golden Signals resources initialized for ${local.service_name}"
  description = "Status message confirming SRE infrastructure deployment."
}
