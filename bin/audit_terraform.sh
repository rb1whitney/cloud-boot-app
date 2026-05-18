#!/bin/bash
set -e
echo "--- Terraform Audit ---"
terraform version | head -n 1
echo "Available Terraform subcommands:"
terraform --help | grep "Common commands:" -A 15
