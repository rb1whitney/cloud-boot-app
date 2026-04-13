[tflint]
  format = "compact"
  plugin_dir = "~/.tflint.d/plugins"
  call_module_type = "local"
  force = false
  disabled_by_default = false

# AWS provider rules
plugin "aws" {
  enabled = true
  version = "0.31.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

# Naming conventions
rule "terraform_naming_convention" {
  enabled = true

  resource {
    format = "snake_case"
  }

  data {
    format = "snake_case"
  }

  module {
    format = "snake_case"
  }

  variable {
    format = "snake_case"
  }

  output {
    format = "snake_case"
  }
}

# Enforce documented variables
rule "terraform_documented_variables" {
  enabled = true
}

# Enforce documented outputs
rule "terraform_documented_outputs" {
  enabled = true
}

# Disallow deprecated interpolation syntax
rule "terraform_deprecated_interpolation" {
  enabled = true
}

# Require type constraints on variables
rule "terraform_typed_variables" {
  enabled = true
}

# Warn on unused declarations
rule "terraform_unused_declarations" {
  enabled = true
}

# Require required providers block
rule "terraform_required_providers" {
  enabled = true
}

# Enforce minimum required_version
rule "terraform_required_version" {
  enabled = true
}
