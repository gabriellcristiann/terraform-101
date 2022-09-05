provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}

terraform {

  required_version = ">1.0, < 2.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

}

variable "produto" {
  description = "mapa de servidores e suas configurações"
  type = map
  default = {
    product_01 = {
      instance_type = "t3.medium",
      name = "product_01"
    },
    product_02 = {
      instance_type = "t3.micro",
      name = "product_02"
    }
  }
  
}

# Nesto bloco definimos o modulo que será trabalhado, e seus ajustes.
module "produto" {
  source        = "git::git@github.com:gabriellcristiann/terraform-module.git//ec2-module?ref=main"
  name          = each.value.name
  enable_sg     = false
  ami           = ""
  key           = "ubuntu-home"
  ingress_port  = [80, 443]
  egress_port   = [80, 443]
  instance_type = each.value.instance_type
  for_each      = var.produto
}

# Neste bloco definimos a saida do terraform, atravez desta saida podemos obter o IP da instancia criada.
output "ip_address" {
  value = values(module.produto)[*].ip_address
}