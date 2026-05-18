#!/bin/bash
set -e
echo "--- Secret Sovereignty Audit ---"
gopass --version || echo "gopass NOT FOUND"
rbw --version || echo "rbw NOT FOUND"
# Check if secrets manager access is available (GCP/AWS)
aws secretsmanager list-secrets --max-items 1 > /dev/null 2>&1 && echo "AWS Secrets Manager: ACCESSIBLE" || echo "AWS Secrets Manager: NOT CONFIGURED"
gcloud secrets list --limit=1 > /dev/null 2>&1 && echo "GCP Secret Manager: ACCESSIBLE" || echo "GCP Secret Manager: NOT CONFIGURED"
