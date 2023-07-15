#configure aws provider
provider "aws" {
  region                  = var.region
  profile                 = "default"
  shared_credentials_file = "~/.aws/credentials"
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}