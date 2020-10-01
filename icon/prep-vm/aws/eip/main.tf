
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

variable "instance_id" {}

resource "aws_eip_association" "this" {
  instance_id = var.instance_id
  public_ip = data.aws_eip.this.public_ip
}