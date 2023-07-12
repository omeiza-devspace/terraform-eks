resource "aws_iam_role" "workers" {
  name = "${var.env}-${var.eks_name}-eks-workers"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "Sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "workers" {
  for_each = var.node_iam_policies

  policy_arn = each.value
  role       = aws_iam_role.workers.name
}

 