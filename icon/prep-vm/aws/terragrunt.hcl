terraform {
// Change in nuki.yaml as well
  source = "github.com/insight-icon/terraform-icon-aws-registration.git?ref=master"
}

dependency "data" {
  config_path = "data"
}


locals {
  # Read the nearest files
  run = yamldecode(file(find_in_parent_folders("run.yml"))) # input
  settings = yamldecode(file(find_in_parent_folders("settings.yml")))
//  secrets = yamldecode(file(find_in_parent_folders("secrets.yml")))

  # Inputs
  deployment_id = join(".", [ for i in local.settings.deployment_id_label_order : lookup(local.run, i)])
  deployment_vars = yamldecode(file("${find_in_parent_folders("deployments")}/${local.deployment_id}.yaml"))
  registration_id = join(".", [ for i in local.settings.registration_id_label_order : lookup(local.run, i)])
  registration_vars = yamldecode(file("${find_in_parent_folders("registrations")}/${local.registration_id}.yaml"))

  # Common labels
  id = join("-", [ for i in local.settings.id_label_order : lookup(local.run, i)])
  name = join("", [ for i in local.settings.name_label_order : title(lookup(local.run, i))])
  tags = { for t in local.settings.remote_state_path_label_order : t => lookup(local.run, t) }

  # Remote State
  remote_state_path = join("/", [ for i in local.settings.remote_state_path_label_order : lookup(local.run, i)])
}


inputs = merge({
  public_ip = dependency.outputs.data.public_ip
},
local,
local.run,
local.deployment_vars,
local.ssh_profile,
local.wallet_profile,
)

generate "provider" {
  path = "provider.tf"
  if_exists = "skip"
  contents =<<-EOF
provider "aws" {
  region = "${local.run.region}"
  skip_get_ec2_platforms     = true
  skip_metadata_api_check    = true
  skip_region_validation     = true
  skip_requesting_account_id = true
}
EOF
}

remote_state {
  backend = "s3"
  config = {
    encrypt = true
    region = "us-east-1"
    key = "${local.remote_state_path}/${path_relative_to_include()}/terraform.tfstate"
    bucket = "terraform-states-${get_aws_account_id()}"
    dynamodb_table = "terraform-locks-${get_aws_account_id()}"
  }

  generate = {
    path = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

