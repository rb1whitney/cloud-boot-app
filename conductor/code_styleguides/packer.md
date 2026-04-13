# Packer Style Guide

Generate and maintain Packer HCL2 templates following HashiCorp official conventions and community best practices.

**References:** [HashiCorp Packer Documentation](https://developer.hashicorp.com/packer) | [HCL2 Template Guide](https://developer.hashicorp.com/packer/docs/templates/hcl_templates)

## Template Structure

All Packer templates use HCL2 format (`.pkr.hcl`). JSON format is deprecated.

```
packer/
├── builds/
│   └── aws-ubuntu/
│       ├── build.pkr.hcl        # build and source blocks
│       ├── variables.pkr.hcl    # variable declarations
│       ├── variables.auto.pkrvars.hcl  # default values (gitignored)
│       └── scripts/
│           ├── provision.sh
│           └── cleanup.sh
└── modules/
    └── shared/
        └── common_sources.pkr.hcl  # reusable source definitions
```

## File Organization

| File | Purpose |
|---|---|
| `build.pkr.hcl` | `source` and `build` blocks |
| `variables.pkr.hcl` | All `variable` declarations |
| `*.auto.pkrvars.hcl` | Default variable values (never commit secrets) |
| `scripts/` | Shell provisioners — one script per concern |

## Code Formatting

- Use **two spaces** per nesting level (no tabs)
- Run `packer fmt -recursive .` before committing
- Align `=` signs for consecutive arguments in the same block

## Source Block Conventions

```hcl
# build.pkr.hcl

packer {
  required_version = ">= 1.9.0"

  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1.0"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  # Identity — what we are building
  ami_name        = "${var.ami_name_prefix}-${var.environment}-${local.timestamp}"
  ami_description = "Ubuntu 22.04 LTS hardened base image for ${var.environment}"

  # Source — what we are building from
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"] # Canonical
  }

  # Instance configuration
  instance_type = var.instance_type
  region        = var.aws_region

  # Network — prefer VPC builds
  vpc_id    = var.vpc_id
  subnet_id = var.subnet_id

  # SSH communicator
  communicator             = "ssh"
  ssh_username             = "ubuntu"
  ssh_timeout              = "10m"
  associate_public_ip_address = false  # Use SSM or private networking

  # Tags — applied to both the AMI and snapshot
  tags = merge(local.common_tags, {
    Name        = "${var.ami_name_prefix}-${var.environment}"
    OS          = "Ubuntu 22.04"
    BuildDate   = local.timestamp
    SourceAMI   = "{{ .SourceAMI }}"
    SourceAMIName = "{{ .SourceAMIName }}"
  })
}
```

## Build Block Conventions

```hcl
build {
  name    = "harden-base"
  sources = ["source.amazon-ebs.ubuntu"]

  # Provisioners run in order — sequence matters
  provisioner "shell" {
    inline = ["sudo apt-get update -q", "sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -yq"]
  }

  provisioner "file" {
    source      = "configs/sshd_config"
    destination = "/tmp/sshd_config"
  }

  provisioner "shell" {
    scripts = [
      "scripts/provision.sh",
      "scripts/harden.sh",
      "scripts/cleanup.sh",  # Always last — removes build artifacts
    ]
    environment_vars = [
      "ENVIRONMENT=${var.environment}",
    ]
    execute_command = "sudo -S bash '{{ .Path }}'"
  }

  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
  }
}
```

## Variable Conventions

```hcl
# variables.pkr.hcl

variable "aws_region" {
  description = "AWS region to build the AMI in"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Target environment: dev, staging, prod"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be dev, staging, or prod."
  }
}

variable "ami_name_prefix" {
  description = "Prefix for the AMI name — used to identify the image family"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the build instance"
  type        = string
  default     = "t3.small"
}
```

## Locals for Computed Values

```hcl
locals {
  timestamp = formatdate("YYYYMMDD-hhmm", timestamp())

  common_tags = {
    ManagedBy   = "Packer"
    Environment = var.environment
    Repository  = "programming-work"
  }
}
```

## Naming Conventions

- **AMI names**: `{prefix}-{environment}-{YYYYMMDD-hhmm}` — always include timestamp for uniqueness
- **Source block labels**: `{platform}_{distro}` (e.g., `amazon-ebs.ubuntu`, `azure-arm.windows_server`)
- **Build names**: Descriptive verb phrase (`harden-base`, `install-agents`, `configure-networking`)
- **Script names**: `{action}.sh` — one action per script (`provision.sh`, `harden.sh`, `cleanup.sh`)

## Security Best Practices

- **Never hardcode** AWS credentials — use IAM instance profiles or environment variables
- **Disable public IP** unless required — use AWS Systems Manager Session Manager for SSH
- **Always run cleanup.sh last** — removes SSH keys, bash history, temp files, unused packages
- **Pin source AMI owners** — never use `*` for owners filter; always specify canonical account IDs
- **Enable encryption** for the root EBS volume:

```hcl
launch_block_device_mappings {
  device_name           = "/dev/sda1"
  volume_size           = 20
  volume_type           = "gp3"
  encrypted             = true
  delete_on_termination = true
}
```

## Cleanup Script Template

Every build must end with a cleanup script:

```bash
#!/usr/bin/env bash
# cleanup.sh — Remove build artifacts before AMI snapshot
set -euo pipefail

# Remove SSH authorized keys
rm -f /home/ubuntu/.ssh/authorized_keys
rm -f /root/.ssh/authorized_keys

# Clear shell history
history -c
cat /dev/null > /root/.bash_history
cat /dev/null > /home/ubuntu/.bash_history

# Remove Packer temp files
rm -f /tmp/packer-*

# Clear package cache
apt-get clean
apt-get autoremove -y

# Zero free space for better compression (optional, slow)
# dd if=/dev/zero of=/EMPTY bs=1M 2>/dev/null; rm -f /EMPTY

echo "Cleanup complete"
```

## Validation and CI Commands

```bash
packer fmt -check -recursive .    # Check formatting
packer validate .                  # Validate template syntax
packer build -var-file=vars.pkrvars.hcl build.pkr.hcl  # Full build

# Debug mode (verbose output)
PACKER_LOG=1 packer build build.pkr.hcl
```

## Code Review Checklist

- [ ] Template uses HCL2 format (not legacy JSON)
- [ ] `packer fmt -recursive .` passes
- [ ] `packer validate .` passes
- [ ] Plugin versions pinned with `~>` constraints
- [ ] AMI name includes timestamp for uniqueness
- [ ] No credentials hardcoded — IAM roles used
- [ ] Cleanup script runs last in provisioner sequence
- [ ] EBS volumes use gp3 and encryption enabled
- [ ] All variables have `description` and `type`
- [ ] Source AMI filter uses specific owner account ID (not `*`)

---

*Based on: [HashiCorp Packer HCL2 Template Guide](https://developer.hashicorp.com/packer/docs/templates/hcl_templates)*
