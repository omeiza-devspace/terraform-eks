resource "aws_iam_role" "clusterRole"{
  name = "${var.env}-eks-cluster"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  }) 
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.clusterRole.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.clusterRole.name
}

resource "aws_eks_cluster" "this" {
  name     = "${var.env}-${var.eks_name}"
  version  = var.eks_version
  role_arn = aws_iam_role.clusterRole.arn
 
  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true

    subnet_ids = var.subnet_ids
  }

  depends_on = [    
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
  ]

}

