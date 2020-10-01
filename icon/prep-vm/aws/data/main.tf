
variable "namespace" {}
variable "network_name" {}
variable "region" {}

data "aws_eip" "this" {
  tags = {
    namespace = var.namespace
    network_name = var.network_name
    region = var.region
  }
}

output "public_ip" {
  value = data.aws_eip.this.public_ip
}
