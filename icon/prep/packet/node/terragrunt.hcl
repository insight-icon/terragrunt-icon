terraform {
  source = "github.com/insight-icon/terraform-icon-packet-prep.git?ref=${local.vars.versions.node}"
}

include {
  path = find_in_parent_folders()
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("variables.hcl")).locals
  registration = find_in_parent_folders("registration")
}

//dependencies {
//  paths = [local.registration]
//}
//
//dependency "registration" {
//  config_path = local.registration
//}

inputs = {
//  public_ip = dependency.registration.outputs.public_ip
  playbook_vars = {
    sync_db = true
  }
}
