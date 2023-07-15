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