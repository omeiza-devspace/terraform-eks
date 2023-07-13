
locals {
  env      = "dev"
  region   = "eu-west-1"
}

#configure aws provider
provider "aws" {
  region                  = local.region
  profile                 = "default"
  shared_credentials_file = "~/.aws/credentials"
}

module "network" {
  source          = "../modules/network"
  env             = local.env
  vpc_cidr_block  = "10.0.0.0/16"
  azs             = ["${local.region}a", "${local.region}b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.5.0/24", "10.0.6.0/24"]

  private_subnet_tags = {
    "kubernetes.io/role/iternal-elb" = 1
    "kubernetes.io/cluster/dev-demo" = "owned"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb"         = 1
    "kubernetes.io/cluster/dev-demo" = "owned"
  }
}

module "eks" {
  source = "../modules/eks"

  env         = local.env
  eks_version = "1.26"
  eks_name    = "demo"
  subnet_ids  = module.network.private_subnet_ids
  vpc_id      = module.network.vpc_id

  node_groups = {
    general = {
      capacity_type  = "ON_DEMAND"
      instance_types = ["t2.micro"]
      scaling_config = {
        desired_size = 1
        min_size     = 0
        max_size     = 1
      }
    }
  }
  ssh_key_pair = "~/.ssh/terraform_ssh_key.pub"
  depends_on   = [module.network]
}

resource "null_resource" "bashctl" {
  depends_on = [module.eks]

  provisioner "local-exec" {
    # connect to eks-cluster nodes
    command     = "aws eks update-kubeconfig --region ${local.region} --name ${module.eks.eks_name}"
    interpreter = ["/bin/bash", "-c"]
  }

  provisioner "local-exec" {
    # deploy nginx-app to eks-cluster
    command     = "./scripts/install-nginx.sh"
    interpreter = ["/bin/bash", "-c"]
  }
}



