terraform {
  // Change in nuki.yaml as well
  source = "github.com/insight-icon/terraform-icon-aws-prep.git?ref=master"
}

include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../data"]
}

dependency "data" {
  config_path = "../data"
}

inputs = {
  public_ip = dependency.data.outputs.public_ip
}
