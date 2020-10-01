terraform {
  source = "github.com/insight-icon/terraform-icon-aws-registration.git?ref=master"
}

locals {
  # Read the nearest files
  run = yamldecode(file(find_in_parent_folders("run.yml"))) # input
  settings = yamldecode(file(find_in_parent_folders("settings.yml")))

  # Inputs
  registration_id = join(".", [ for i in local.settings.registration_id_label_order : lookup(local.run, i)])
  registration_vars = yamldecode(file("${find_in_parent_folders("registrations")}/${local.registration_id}.yaml"))

  # Common labels
  tags = { for t in local.settings.registration_remote_state_path_label_order : t => lookup(local.run, t) }

  # Remote State
  remote_state_path = join("/", [ for i in local.settings.registration_remote_state_path_label_order : lookup(local.run, i)])
}

inputs = merge(
local,
local.run,
local.registration_vars,
//local.wallet_profile,
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

