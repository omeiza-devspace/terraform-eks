
locals {
  env           = "dev"
  region        = "eu-west-1"
  cluster_name  = "eks-demo"
  vpc_cidr      = "10.0.0.0/16"
  available_azs = formatlist("${local.region}%s", ["a", "b"])
  public_subnets = [
    for i in range(length(local.available_azs)) : cidrsubnet(local.vpc_cidr, 8, i)
  ]

  private_subnets = [
    for i in range(length(local.available_azs)) : cidrsubnet(local.vpc_cidr, 8, i + 10)
  ]
}

#configure aws provider
provider "aws" {
  region                  = local.region
  profile                 = "default"
  shared_credentials_file = "~/.aws/credentials"
}

module "network" {
  source   = "../modules/network"
  env      = local.env
  vpc_cidr = local.vpc_cidr

  azs                  = local.available_azs
  private_subnet_cidrs = local.private_subnets
  public_subnet_cidrs  = local.public_subnets

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"             = 1
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb"                      = 1
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }
}

module "eks" {
  source = "../modules/eks"

  env         = local.env
  eks_version = "1.26"
  eks_name    = local.cluster_name
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



