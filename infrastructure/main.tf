
locals {
  available_azs = formatlist("${var.region}%s", var.region_list)

  public_subnets = [
    for i in range(length(local.available_azs)) : cidrsubnet(var.vpc_cidr, 8, i)
  ]

  private_subnets = [
    for i in range(length(local.available_azs)) : cidrsubnet(var.vpc_cidr, 8, i + 10)
  ]
}

# set up the VPC
module "network" {
  source   = "../modules/network"
  env      = var.env
  vpc_cidr = var.vpc_cidr

  support_vpc_dns      = true
  support_vpc_hostname = true

  azs                  = local.available_azs
  private_subnet_cidrs = local.private_subnets
  public_subnet_cidrs  = local.public_subnets

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"           = 1
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb"                    = 1
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

# set up the EKS Cluster
module "eks" {
  source     = "../modules/eks"
  depends_on = [module.network]

  env         = var.env
  eks_version = var.eks_version
  eks_name    = var.cluster_name
  subnet_ids  = module.network.private_subnet_ids
  vpc_id      = module.network.vpc_id

  webhook_port = var.alb_webhook_port
  ssh_key_pair = var.ssh_key_pair

  node_groups = {
    general = {
      capacity_type  = "ON_DEMAND"
      instance_types = var.instance_types

      scaling_config = {
        desired_size = var.desired_size
        min_size     = var.min_size
        max_size     = var.max_size
      }
    }
  }
}

# deploy the nginx-app 
resource "null_resource" "bashctl" {
  depends_on = [module.eks]

  provisioner "local-exec" {
    # connect to eks-cluster nodes
    command     = "aws eks update-kubeconfig --region ${var.region} --name ${module.eks.eks_name}"
    interpreter = ["/bin/bash", "-c"]
  }

  provisioner "local-exec" {
    # deploy nginx-app to eks-cluster
    command     = "chmod u+x ./scripts/* && ./scripts/install-nginx.sh"
    interpreter = ["/bin/bash", "-c"]
  }
}

# create worker nodes alb-iam-policy
resource "aws_iam_policy" "worker_policy" {
  name        = "worker-policy"
  description = "Worker policy for the ALB Ingress"

  policy = file("./aws_policies/iam-policy.json")
}

# attach worker nodes alb-iam-policy
resource "aws_iam_role_policy_attachment" "additional" {
  for_each = module.eks.eks_managed_node_groups

  policy_arn = aws_iam_policy.worker_policy.arn
  role       = each.value.node_group_name
}

# setup ingrss alb using helm
resource "helm_release" "ingress" {
  name       = "ingress"
  chart      = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  version    = "1.4.6"

  set {
    name  = "autoDiscoverAwsRegion"
    value = "true"
  }
  set {
    name  = "autoDiscoverAwsVpcID"
    value = "true"
  }
  set {
    name  = "clusterName"
    value = var.cluster_name
  }
}
