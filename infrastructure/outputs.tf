output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet
}

output "cluster_name" {
  value = module.eks.eks_name
}