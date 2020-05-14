locals {
  vars = read_terragrunt_config(find_in_parent_folders("${get_parent_terragrunt_dir()}/variables.hcl"))
}

remote_state {
  backend = "gcs"
  config = {
    encrypt = true
    region = "us-east1"
    key = "${local.vars.locals.remote_state_path}/${path_relative_to_include()}/terraform.tfstate"
    bucket = "terraform-states-${local.vars.locals.account_alias}"
    dynamodb_table = "terraform-locks-${local.vars.locals.account_alias}"
  }

  generate = {
    path = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

inputs = merge(
local.vars.locals,
local.vars.locals.env_vars,
local.vars.locals.secrets,
)

generate "provider" {
  path = "provider.tf"
  if_exists = "skip"
  contents =<<-EOF
variable "gcp_region" {
  default = "us-east1"
}

variable "gcp_project" {}

provider "google" {
  region  = var.gcp_region
  project = var.gcp_project
}
EOF
}
