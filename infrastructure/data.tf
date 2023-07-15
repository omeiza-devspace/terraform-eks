# get all available AZs in our region
data "aws_availability_zones" "available_azs" {
  state = "available"
}

data "aws_region" "current" {}

# used for accesing Account ID and ARN
data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "this" {
  name = module.eks.eks_id
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.eks_id
}
 