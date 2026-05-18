#!/bin/bash
set -e
echo "--- Maven Audit ---"
mvn -version | head -n 1
echo "Project info:"
mvn help:effective-pom -Dminimal=true | grep -E "<groupId>|<artifactId>|<version>" | head -n 5
