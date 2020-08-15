terraform {
  source = "github.com/insight-harmony/terraform-harmony-aws-node.git?ref=${local.versions}"
}

locals {
  # Read the nearest files
  run = yamldecode(file(find_in_parent_folders("run.yml"))) # input
  settings = yamldecode(file(find_in_parent_folders("settings.yml")))
  secrets = yamldecode(file(find_in_parent_folders("secrets.yml")))
  versions = yamldecode(file("versions.yaml"))[local.run.environment]

  # Inputs
  deployment_id = join(".", [ for i in local.settings.deployment_id_label_order : lookup(local.run, i)])
  deployment_vars = yamldecode(file("${find_in_parent_folders("deployments")}/${local.deployment_id}.yaml"))
  ssh_profile = local.secrets.ssh_profiles[index(local.secrets.ssh_profiles.*.name, local.deployment_vars.ssh_profile_name)]
  wallet_profile = local.secrets.wallet_profiles[index(local.secrets.wallet_profiles.*.name, local.deployment_vars.wallet_profile_name)]

  # Common labels
  id = join("-", [ for i in local.settings.id_label_order : lookup(local.run, i)])
  short_id = join("-", [ for i in local.settings.short_id_label_order : lookup(local.run, i)])
  name = join("", [ for i in local.settings.name_label_order : title(lookup(local.run, i))])
  tags = { for t in local.settings.remote_state_path_label_order : t => lookup(local.run, t) }

  # Remote State
  remote_state_path = join("/", [ for i in local.settings.remote_state_path_label_order : lookup(local.run, i)])
}


inputs = merge({
  vpc_name = local.id
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

provider "cloudflare" {
  version = "~> 2.0"
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

