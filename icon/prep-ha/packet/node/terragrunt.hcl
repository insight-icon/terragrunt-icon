terraform {
  source = "github.com/insight-icon/terraform-icon-aws-prep.git?ref=${local.vars.versions.node}"
}

include {
  path = find_in_parent_folders()
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("variables.hcl")).locals
  registration = find_in_parent_folders("registration")
}

dependencies {
  paths = [local.registration]
}

dependency "network" {
  config_path = local.registration
}

inputs = {
  name = "${local.vars["namespace"]}-main"

  associate_eip = false

  subnet_id = dependency.network.outputs.public_subnets[0]
  vpc_security_group_ids = [dependency.network.outputs.prep_security_group_id]

  playbook_vars = {
    sync_db = true
  }
}
