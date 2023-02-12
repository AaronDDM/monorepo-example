# Description: This file is the root Terragrunt configuration file for the GCP infrastructure. It is responsible for
# generating the provider block and merging the variables from the parent Terragrunt configuration files.
# Reference: https://github.com/gruntwork-io/terragrunt-infrastructure-live-example/blob/master/terragrunt.hcl

locals {
  # Automatically load org-level variables
  organization_vars = read_terragrunt_config(find_in_parent_folders("organization.hcl"))
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))

  # Easily reference the variables
  organization_name = local.organization_vars.locals.organization_name
  environment       = local.environment_vars.locals.environment
  gcp_project       = local.account_vars.locals.gcp_project
  region            = local.region_vars.locals.region
  region_short      = local.region_vars.locals.region_short

  # Prefix for all resources
  name_prefix = "${local.organization_name}-${local.region_short}-${local.environment}"
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "google" {
  region      = "${local.region}"
  project     = "${local.gcp_project}"
}
EOF
}

# Remote state
remote_state {
  backend = "gcs"

  config = {
    project  = "${local.gcp_project}"
    location = "${local.region}"
    bucket   = "${get_env("TG_BUCKET_PREFIX", "")}tf-state-${local.organization_name}-${local.region}"
    prefix   = "${path_relative_to_include()}/terraform.tfstate"

    gcs_bucket_labels = {
      owner = "terragrunt_test"
      name  = "terraform_state_storage"
    }
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

inputs = merge(
  local.organization_vars.locals,
  local.account_vars.locals,
  local.region_vars.locals,
  local.environment_vars.locals,
  {
    # The name of the GCP project
    project_id = "${local.gcp_project}"

    # The name of the GCP region
    region = "${local.region}"

    # The name of the environment
    environment = "${local.environment}"

    # The name of the organization
    organization_name = "${local.organization_name}"
  },
)
