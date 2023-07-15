output "vpc_id" {
  value = module.network.vpc_id
}

output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "cluster_name" {
  value = module.eks.eks_name
}

output "cluster_endpoint" {
  value = module.eks.eks_endpoint
}

output "private_url" {
  value = aws_route53_zone.this.arn
}

