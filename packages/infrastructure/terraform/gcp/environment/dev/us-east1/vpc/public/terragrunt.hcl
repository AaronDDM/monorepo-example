include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_path_to_repo_root()}//packages/infrastructure/terraform/gcp/module/vpc"
}

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

  # Module-specific variables
  vpc_name          = "public"
}

inputs = {
  vpc_name    = "${local.organization_name}-${local.environment}-${local.vpc_name}"
  region      = "${local.region}"
  gcp_project = "${local.gcp_project}"
}
