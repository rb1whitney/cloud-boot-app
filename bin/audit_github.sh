#!/bin/bash
set -e
echo "--- GitHub Audit ---"
gh --version | head -n 1
echo "Available gh subcommands:"
gh --help | grep "Available commands:" -A 15
