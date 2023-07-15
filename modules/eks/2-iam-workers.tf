resource "aws_iam_role" "workerGroup" {
  name = "${var.env}-eks-workers"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "worker_policies" {
  for_each = var.worker_node_iam_policies

  policy_arn = each.value
  role       = aws_iam_role.workerGroup.name
}
 

 


 