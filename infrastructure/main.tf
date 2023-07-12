
module "vpc" {
  source          = "../modules/vpc"
  env             = "dev"
  azs             = []
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

# create  security groups
module "sec_groups" {
  source = "../modules/sec_groups"

  env = module.vpc.vpc_name
  vpc_id   = module.vpc.vpc_id
}

module "eks" {
  source = "../modules/eks"

  env         = "dev"
  eks_version = "1.26"
  eks_name    = "demo"
  subnet_ids  = module.vpc.outputs.private_subnet_ids

  node_groups = {
    general = {
      capacity_type  = "ON_DEMAND"
      instance_types = ["t2.micro"]
      scaling_config = {
        desired_size = 1
        min_size     = 0
        max_size     = 10
      }
    }
  }
  ssh_key_pair = "~/.ssh/terraform_ssh_key.pub"
  sec_group_id = module.sec_groups.worker_nodes_sg_id
  depends_on = [module.vpc]
}








