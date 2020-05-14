terraform {
  source = "github.com/insight-icon/terraform-icon-azure-network.git?ref=${local.vars.versions.prep.azure.network}"
}

include {
  path = find_in_parent_folders()
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("variables.hcl")).locals
}

inputs = {}