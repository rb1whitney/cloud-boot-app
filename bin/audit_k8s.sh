#!/bin/bash
set -e
echo "--- K8s/GitOps Audit ---"
kubectl version --client | head -n 1
helm version --short
argocd version --client | head -n 1 || echo "argocd not installed"
crossplane version || echo "crossplane not installed"
gator --version || echo "gator not installed"
