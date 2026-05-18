#!/bin/bash
set -e
echo "--- Application Audit ---"
mvn -version | head -n 1
make --version | head -n 1
bash --version | head -n 1
java -version 2>&1 | head -n 1
echo "Available Makefile targets:"
make -qp | awk -F':' '/^[a-zA-Z0-9][^0\/\t=]*:([^=]|$)/ {split($1,A,/ /);for(i in A)print A[i]}' | sort -u | grep -v 'Makefile'
