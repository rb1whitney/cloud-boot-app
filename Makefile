# Cloud Boot App - Modernized Makefile for Local Linting & Testing
SHELL := /bin/bash

# Tool Discovery Logic
HOMEBREW_BIN := /home/linuxbrew/.linuxbrew/bin
MVN       := $(shell which mvn || echo $(HOMEBREW_BIN)/mvn)
TERRAFORM := $(shell which terraform || echo $(HOMEBREW_BIN)/terraform)
TFLINT    := $(shell which tflint || echo $(HOMEBREW_BIN)/tflint)
HELM      := $(shell which helm || echo $(HOMEBREW_BIN)/helm)
OPA       := $(shell which opa || echo $(HOMEBREW_BIN)/opa)
# Tool Discovery Logic (Prioritize PATH, fallback to Homebrew/Local)
# Usage: $(call BIN_DISCOVERY,toolname)
BIN_DISCOVERY = $(shell which $(1) 2>/dev/null || ls /usr/local/bin/$(1) 2>/dev/null || ls /home/linuxbrew/.linuxbrew/bin/$(1) 2>/dev/null || echo $(1))

MVN       := $(call BIN_DISCOVERY,mvn)
TERRAFORM := $(call BIN_DISCOVERY,terraform)
TFLINT    := $(call BIN_DISCOVERY,tflint)
HELM      := $(call BIN_DISCOVERY,helm)
OPA       := $(call BIN_DISCOVERY,opa)
HADOLINT  := $(call BIN_DISCOVERY,hadolint)
CHECKOV   := $(call BIN_DISCOVERY,checkov)

.PHONY: lint lint-java lint-hcl lint-helm lint-opa lint-docker test test-java test-iac debug-env

# Default target runs all linters
lint: debug-env lint-java lint-hcl lint-helm lint-opa lint-docker

.NOTPARALLEL:

debug-env:
	@echo "==> Debugging Environment..."
	@echo "PATH: $(PATH)"
	@echo "HADOLINT Location: $(HADOLINT)"
	@echo "TFLINT Location: $(TFLINT)"
	@$(HADOLINT) --version || echo "Warning: Hadolint not found. Skipping docker lint."

# 1. Java Linting (Maven)
lint-java:
	@echo "==> Compiling Java with Maven..."
	$(MVN) compile

# 2. Terraform/HCL Linting & Validation
lint-hcl:
	@echo "==> Running Terraform Format Check..."
	$(TERRAFORM) fmt -recursive -check terraform/
	@echo "==> Validating Terraform Modules..."
	find terraform/ -name "*.tf" -exec dirname {} \; | sort -u | xargs -I {} sh -c "cd {} && $(TERRAFORM) init -backend=false && $(TERRAFORM) validate"
	@echo "==> Initializing TFLint..."
	$(TFLINT) --init --config $(shell pwd)/.tflint.hcl
	@echo "==> Running TFLint..."
	find terraform/ -name "*.tf" -exec dirname {} \; | sort -u | xargs -I {} $(TFLINT) --chdir={} --config $(shell pwd)/.tflint.hcl

# 3. Helm Chart Linting
lint-helm:
	@echo "==> Linting Helm Chart..."
	$(HELM) lint helm/cloud-boot-app

# 4. OPA Policy Linting & Testing
lint-opa:
	@echo "==> Validating OPA Policy logic (Rego Tests)..."
	$(OPA) test gatekeeper/tests/ -v

# 5. Dockerfile Linting
lint-docker:
	@echo "==> Linting Dockerfile..."
	@if [ -x "$(HADOLINT)" ] || which hadolint >/dev/null 2>&1; then \
		$(HADOLINT) Dockerfile; \
	else \
		echo "Skipping Hadolint: binary not found in PATH or standard locations."; \
	fi

# Testing Targets
test: test-java test-iac

test-java:
	@echo "==> Running JUnit tests..."
	$(MVN) test

test-iac:
	@echo "==> Running Terraform Logic Tests..."
	find terraform/ -type d -name "tests" -exec dirname {} \; | sort -u | xargs -I {} sh -c "cd {} && $(TERRAFORM) init -backend=false && $(TERRAFORM) test"
	@echo "==> Running Security Scan (Checkov)..."
	$(CHECKOV) -d terraform/ --quiet --compact
	$(CHECKOV) -d helm/cloud-boot-app --quiet --compact
