provider "aws" {
  region = var.region
}

terraform {
  backend "local" {
    path = "dev/vpc/terraform.tstate"
  }
}

module "vpc" {
  source          = "../../../modules/vpc"
  env             = "dev"
  azs             = []
  private_subnets = []
  public_subnets  = []

  private_subnet_tags = {
    "kubernetes.io/role/iternal-elb" = 1
    "kubernetes.io/cluster/dev-demo" = "owned"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb"         = 1
    "kubernetes.io/cluster/dev-demo" = "demo"
  }
}