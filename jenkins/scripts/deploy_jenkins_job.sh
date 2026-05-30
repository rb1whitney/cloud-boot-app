#!/bin/bash

# Save Previous Options
ORIGINAL_OPTS="$(set +o); set -$-"

# Set Built-In Options
set -o errexit
set -o nounset

# Unset options
trap 'rc=$?;eval "$ORIGINAL_OPTS";trap - EXIT; exit $rc' EXIT

JOB_NAME=""
JENKINS_ENDPOINT="http://localhost:8080"
INPUT_PATH=""
USERNAME="admin"
PASSWORD=""

# Process each argument and shift past argument and value
while [ $# -gt 0 ]; do
    ARG_NAME="$1"
    case $ARG_NAME in
    -j | --job-name)
        JOB_NAME="$2"
        shift
        shift
        ;;
    -e | --endpoint)
        JENKINS_ENDPOINT="$2"
        shift
        shift
        ;;
    -i | --input-path)
        INPUT_PATH="$2"
        shift
        shift
        ;;
    -u | --username)
        USERNAME="$2"
        shift
        shift
        ;;
    -p | --password)
        PASSWORD="$2"
        shift
        shift
        ;;
    *)
        echo -e "Unexpected Arguments passed to script"
        exit 1
        ;;
    esac
done

# Set Path to Job Name
if [ -z "$INPUT_PATH" ]; then
    INPUT_PATH="config/$JOB_NAME.xml"
fi

# Get Initial Jenkins Password from Jenkins Container if not passed
if [ -z "$PASSWORD" ]; then
    CONTAINER_ID=$(docker ps -aqf "name=jenkins")
    PASSWORD=$(docker exec -w /var/jenkins_home/secrets $CONTAINER_ID /bin/bash -c 'cat initialAdminPassword')
fi

# Push Job Definition to Jenkins
CRUMB=$(curl -s "$JENKINS_ENDPOINT/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)" -u $USERNAME:$PASSWORD)
curl -s -X POST "$JENKINS_ENDPOINT/createItem?name=$JOB_NAME" -u $USERNAME:$PASSWORD --data-binary @$INPUT_PATH -H "$CRUMB" -H 'Content-Type:text/xml'
