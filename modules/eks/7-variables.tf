variable "env" {
  type        = string
  description = "environment name"
  default     = "dev"
}

variable "eks_version" {
  type        = string
  description = "Desired  kubernetes version"
  default     = "dev"
}

variable "eks_name" {
  type        = string
  description = "name assigned ti the cluster"
  default     = "dev"
}

variable "subnet_ids" {
  type        = list(string)
  description = "list of subnet IDs in atleast two different AZs"
}

variable "node_iam_policies" {
  type        = map(any)
  description = "IAM policies attached to the managed nodes"
  default = {
    1 = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    2 = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    3 = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    4 = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
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

variable "sec_group_id" {
  description = "Security group firewall for access to the worker nodes"
}
