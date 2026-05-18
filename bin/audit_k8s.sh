#!/bin/bash
set -e
echo "--- K8s/GitOps Audit ---"
kubectl version --client | head -n 1 || echo "kubectl NOT FOUND"
helm version --short || echo "helm NOT FOUND"
argocd version --client | head -n 1 || echo "argocd NOT FOUND (Install: brew install argocd)"
crossplane version || echo "crossplane NOT FOUND (Install: brew install crossplane)"
gator --version || echo "gator NOT FOUND (Install: see README.md for binary download)"
