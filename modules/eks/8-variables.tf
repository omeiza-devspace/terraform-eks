variable "env" {
  type        = string
  description = "environment name"
}

variable "eks_version" {
  type        = string
  description = "Desired  kubernetes version"
}

variable "eks_name" {
  type        = string
  description = "name assigned ti the cluster"
}

variable "subnet_ids" {
  type        = list(string)
  description = "list of subnet IDs in atleast two different AZs"
}

variable "worker_node_iam_policies" {
  type        = map(any)
  description = "IAM policies attached to the managed nodes"
  default = {
    1 = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    2 = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    3 = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    4 = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    5 = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
    6 = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  }
}

variable "ssh_key_pair" {
  description = "SSH keypair file to connect to the worker nodes"
  type        = string
}

variable "node_groups" {
  description = "EKS Node groups"
  type        = map(any)
}


variable "enable_irsa" {
  description = "Option to create an OpenID Connect Provider for EKS"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "VPC the resource is attached to"
}

variable "webhook_port" {
    description = "Load Balancer webhook controller port"
}
