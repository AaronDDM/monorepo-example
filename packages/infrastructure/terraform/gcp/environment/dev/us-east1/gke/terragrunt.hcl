# Module-specific variables
# -------------------------
locals {
  cluster_name = "services"
}

# Module setup
# -------------------------
include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "github.com/terraform-google-modules/terraform-google-kubernetes-engine//.?ref=v25.0.0"
}

# Dependencies
# -------------------------
dependency "vpc" {
  config_path = "../vpc/private"
}

inputs = {
  name                = "${include.root.locals.name_prefix}-${local.cluster_name}"
  cluster_name_suffix = "-${local.cluster_name}"
  network             = "${dependency.vpc.outputs.network_name}"
  subnetwork          = "${dependency.vpc.outputs.subnets_names[0]}"
  ip_range_pods       = ""
  ip_range_services   = ""
}
