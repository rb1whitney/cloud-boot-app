# Cloud Boot App - Modernized Makefile for Local Linting & Testing
SHELL := /bin/bash

# Ensure Homebrew and local binaries are in the PATH
export PATH := /home/linuxbrew/.linuxbrew/bin:$(PATH)

.PHONY: lint lint-java lint-hcl lint-helm lint-opa lint-docker test test-java test-iac

# Default target runs all linters
lint: lint-java lint-hcl lint-helm lint-opa lint-docker

.NOTPARALLEL:

# 1. Java Linting (Maven)
lint-java:
	@echo "==> Compiling Java with Maven..."
	mvn compile

# 2. Terraform/HCL Linting & Validation
lint-hcl:
	@echo "==> Running Terraform Format Check..."
	terraform fmt -recursive -check terraform/
	@echo "==> Validating Terraform Modules..."
	find terraform/ -name "*.tf" -exec dirname {} \; | sort -u | xargs -I {} sh -c "cd {} && terraform init -backend=false && terraform validate"
	@echo "==> Initializing TFLint..."
	tflint --init --config $(shell pwd)/.tflint.hcl
	@echo "==> Running TFLint..."
	find terraform/ -name "*.tf" -exec dirname {} \; | sort -u | xargs -I {} tflint --chdir={} --config $(shell pwd)/.tflint.hcl

# 3. Helm Chart Linting
lint-helm:
	@echo "==> Linting Helm Chart..."
	helm lint helm/cloud-boot-app

# 4. OPA Policy Linting & Testing
lint-opa:
	@echo "==> Validating OPA Policy logic (Rego Tests)..."
	opa test gatekeeper/tests/ -v

# 5. Dockerfile Linting
lint-docker:
	@echo "==> Linting Dockerfile..."
	hadolint Dockerfile

# Testing Targets
test: test-java test-iac

test-java:
	@echo "==> Running JUnit tests..."
	mvn test

test-iac:
	@echo "==> Running Terraform Logic Tests..."
	find terraform/ -type d -name "tests" -exec dirname {} \; | sort -u | xargs -I {} sh -c "cd {} && terraform init -backend=false && terraform test"
	@echo "==> Running Security Scan (Checkov)..."
	checkov -d terraform/ --quiet --compact
	checkov -d helm/cloud-boot-app --quiet --compact
