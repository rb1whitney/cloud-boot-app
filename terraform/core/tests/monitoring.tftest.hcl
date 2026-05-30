# Terraform Test for SRE Monitoring
variables {
  aws_region           = "us-east-1"
  env_prefix           = "test"
  vpc_id               = "vpc-12345"
  vpc_cidr             = "10.0.0.0/16"
  db_password          = "Password123!"
  oidc_provider_arn    = "arn:aws:iam::123456789012:oidc-provider/test"
  oidc_provider_url    = "oidc.eks.us-east-1.amazonaws.com/id/test"
  namespace            = "test-ns"
  service_account_name = "test-sa"
  db_username          = "admin"
}

run "verify_golden_signals_filters" {
  command = plan

  assert {
    condition     = length(aws_cloudwatch_log_metric_filter.latency) > 0
    error_message = "Latency metric filter is missing"
  }

  assert {
    condition     = length(aws_cloudwatch_log_metric_filter.traffic) > 0
    error_message = "Traffic metric filter is missing"
  }

  assert {
    condition     = length(aws_cloudwatch_log_metric_filter.errors) > 0
    error_message = "Errors metric filter is missing"
  }

  assert {
    condition     = length(aws_cloudwatch_log_metric_filter.saturation) > 0
    error_message = "Saturation metric filter is missing"
  }
}

run "verify_cloudwatch_alarms" {
  command = plan

  assert {
    condition     = length(aws_cloudwatch_metric_alarm.high_latency) > 0
    error_message = "High latency alarm is missing"
  }

  assert {
    condition     = length(aws_cloudwatch_metric_alarm.high_error_rate) > 0
    error_message = "High error rate alarm is missing"
  }
}
