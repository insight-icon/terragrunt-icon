terraform {
  source = "."
}

include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../node"]
}

dependency "node" {
  config_path = "../node"
}

inputs = {
  instance_id = dependency.node.outputs.instance_id
}
