#!/bin/bash
env=$1
app=$2
action=$3

# Ensure old configuration is gone so previous environments don't get mixed up
rm -rf ./.terraform

# Access remote configuration
terraform remote config -backend=s3 -backend-config="bucket=tf-remote-state-storage" -backend-config="key=terraform-$1-$2.tfstate" -backend-config="region=us-east-1" -backend-config="encrypt=true"
terraform remote pull

# Get all modules if needed
terraform get module-groups/$app

# Apply Changes
terraform $action ${*:4} -var-file="config/var-files/$app/$env.tfvars" module-groups/$app