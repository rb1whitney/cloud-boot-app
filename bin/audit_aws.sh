#!/bin/bash
set -e
echo "--- AWS Audit ---"
aws --version
echo "Available AWS subcommands:"
aws help | grep -A 20 "AVAILABLE SERVICES" | tail -n +2
