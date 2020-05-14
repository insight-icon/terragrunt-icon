terraform {
  source = "github.com/insight-icon/terraform-icon-gcp-network.git?ref=${local.vars.versions.prep.gcp.network}"
}

include {
  path = find_in_parent_folders()
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("variables.hcl")).locals
}

inputs = {}