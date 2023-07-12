resource "aws_eks_node_group" "this" {
  for_each        = var.node_groups
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = each.key
  node_role_arn   = aws_iam_role.workers.arn

  subnet_ids = var.subnet_ids

  capacity_type  = each.value.capacity_type
  instance_types = each.value.instance_types

  scaling_config {
    desired_size = each.value.scaling_config.desired_size
    max_size     = each.value.scaling_config.max_size
    min_size     = each.value.scaling_config.min_size
  }

  remote_access {
    ec2_ssh_key               = aws_key_pair.this.id
    source_security_group_ids = [var.sec_group_id]
  }

  update_config {
    max_unavailavble = 1
  }

  labels = {
    role = each.key
  }

  depnds_on = [aws_iam_role_policy_attachment.workers]
}