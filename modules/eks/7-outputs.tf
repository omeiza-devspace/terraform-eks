
output "id" {
  description = "Name of the cluster."
  value       = aws_eks_cluster.this.id
}

output "arn" {
  description = "EKS Cluster ARN"
  value       = aws_eks_cluster.this.arn
}

output "host" {
  description = "Endpoint for your Kubernetes API server."
  value       = aws_eks_cluster.this.endpoint
}

output "cert" {
  description = "Certificate authority"
  value       = aws_eks_cluster.this.certificate_authority.0.data
}

output "identity" {
  description = "Attribute block containing identity provider information for your cluster"
  value       = aws_eks_cluster.this.identity
}
output "vpc_id" {
  description = "ID of the VPC associated with your cluster."
  value       = aws_eks_cluster.this.vpc_config.0.vpc_id
}

output "cluster_security_group_id" {
  description = "Cluster security group that was created by Amazon EKS for the cluster. Managed node groups use this security group for control-plane-to-data-plane communication."
  value       = aws_eks_cluster.this.vpc_config.0.cluster_security_group_id
}

output "eks_name" {
  value = aws_eks_cluster.this.name
}

output "eks_id" {
  value = aws_eks_cluster.this.id
}

output "eks_managed_node_groups" {
  value = aws_eks_node_group.this
}

output "eks_endpoint" {
  value = "${aws_eks_cluster.this.endpoint}"
}

output "openid_provider_arn" {
  value = aws_iam_openid_connect_provider.this[0].arn
}

