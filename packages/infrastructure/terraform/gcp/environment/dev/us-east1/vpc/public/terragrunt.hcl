# Module-specific variables
# -------------------------
locals {
  # Easily reference the variables
  gcp_region        = include.root.locals.region
  
  # Module-specific variables
  vpc_name          = "${basename(get_terragrunt_dir())}"
}

# Module setup
# -------------------------
include "root" {
  path = find_in_parent_folders()
  expose = true
}

terraform {
  source       = "github.com/terraform-google-modules/terraform-google-network//.?ref=v6.0.1"
}

inputs = {
  network_name = "${include.root.locals.name_prefix}-${local.vpc_name}"
  mtu          = 1460

  subnets = [
    {
      subnet_name   = "services"
      subnet_ip     = "10.20.10.0/24"
      subnet_region = "${local.gcp_region}"
    },
    # {
    #   subnet_name               = "subnet-03"
    #   subnet_ip                 = "10.20.20.0/24"
    #   subnet_region             = "${local.gcp_region}"
    #   subnet_flow_logs          = "true"
    #   subnet_flow_logs_interval = "INTERVAL_10_MIN"
    #   subnet_flow_logs_sampling = 0.7
    #   subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
    #   subnet_flow_logs_filter   = "false"
    # }
  ]
}
