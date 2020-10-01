locals {
  vars = read_terragrunt_config(find_in_parent_folders("${get_parent_terragrunt_dir()}/variables.hcl")).locals
}


inputs = merge(
local.vars,
local.vars.run,
local.vars.deployment_vars,
local.vars.registration_vars
)

generate "provider" {
  path = "provider.tf"
  if_exists = "skip"
  contents =<<-EOF
provider "aws" {
  region = "${local.vars.run.region}"
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
    key = "${local.vars.remote_state_path}/${path_relative_to_include()}/terraform.tfstate"
    bucket = "terraform-states-${get_aws_account_id()}"
    dynamodb_table = "terraform-locks-${get_aws_account_id()}"
  }

  generate = {
    path = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

