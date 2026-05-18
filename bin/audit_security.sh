#!/bin/bash
set -e
echo "--- Security Audit ---"
checkov --version || echo "checkov not installed"
tflint --version
hadolint --version
