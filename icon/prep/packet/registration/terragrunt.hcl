terraform {
  source = "github.com/insight-icon/terraform-icon-packet-registration.git?ref=${local.vars.versions.registration}"
}

include {
  path = find_in_parent_folders()
}

skip = !local.vars.registration_enabled

locals {
  vars = read_terragrunt_config(find_in_parent_folders("variables.hcl")).locals
}

inputs = yamldecode(file(find_in_parent_folders(local.vars.registration_file)))
