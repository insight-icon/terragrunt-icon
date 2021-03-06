terraform {
  source = "github.com/insight-icon/terraform-icon-aws-prep.git?ref=${local.vars.versions.node}"
}

include {
  path = find_in_parent_folders()
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("variables.hcl")).locals
  network = find_in_parent_folders("network")
  registration = find_in_parent_folders("registration")
}

dependencies {
  paths = [local.network, local.vars.registration_enabled ? local.registration : ""]
}

dependency "network" {
  config_path = local.network
}

dependency "registration" {
  config_path = local.registration
  skip_outputs = !local.vars.registration_enabled
}

inputs = {
  public_ip = local.vars.registration_enabled ? dependency.registration.outputs.public_ip : local.vars.secrets.public_ip
  subnet_id = dependency.network.outputs.public_subnets[0]
  vpc_security_group_ids = [dependency.network.outputs.prep_security_group_id]

  associate_eip = false
  playbook_vars = {}
}
