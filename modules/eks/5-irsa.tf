data "tls_certificate" "this" {
  count = var.enable_irsa ? 1 : 0

  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

resource "aws_iam_open_id_connect_provider" "this" {
  count = var.enable_irsa ? 1 : 0

  client_id_list  = ["sts.amazon.com"]
  thumbprint_list = [data.tl_certificate.this[0].certificates[0].sha1_fingerprint]
  url             = aws_ks_cluster.this.identity[0].oidc[0].issuer
}