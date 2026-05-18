#!/bin/bash
set -e
echo "--- SRE Audit ---"
kubectl top node --help | head -n 5 || echo "kubectl top node not available"
jcmd -h 2>&1 | head -n 5 || echo "jcmd not available"
jstack -h 2>&1 | head -n 5 || echo "jstack not available"
