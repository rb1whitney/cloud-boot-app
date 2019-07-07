#!/bin/bash

# Save Previous Options
ORIGINAL_OPTS="$(set +o); set -$-"

# Set Built-In Options
set -o errexit
set -o nounset

# Unset to debug script
# set -x

# Unset options
trap 'rc=$?;eval "$ORIGINAL_OPTS";trap - EXIT; exit $rc' EXIT

ACTION_OPTS=""
ACTION="plan"

# Process each argument and shift past argument and value
while [ $# -gt 0 ]; do
  ARG_NAME="$1"
  case $ARG_NAME in
  -e | --environment)
    ENV="$2"
    shift
    shift
    ;;
  -m | --module_group)
    MODULE_GROUP="$2"
    shift
    shift
    ;;
  -a | --action)
    ACTION="$2"
    shift
    shift
    ;;
  -o | --action-options)
    ACTION_OPTS="$2"
    shift
    shift
    ;;
  *)
    echo -e "Unexpected Arguments passed to script"
    exit 1
    ;;
  esac
done

# Ensure old configuration is gone so previous environments don't get mixed up
rm -rf working_dir
mkdir -p working_dir
cd working_dir

# Get all modules if needed
terraform get ../module-groups/$MODULE_GROUP
terraform init -backend-config="../config/backend-config/$MODULE_GROUP/$ENV.tfvars" -input=false -backend=true ../module-groups/$MODULE_GROUP

# Apply Changes
terraform $ACTION $ACTION_OPTS -var-file="../config/var-files/$MODULE_GROUP/$ENV.tfvars" ../module-groups/$MODULE_GROUP
