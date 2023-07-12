###########################
# VPC
###########################
variable "vpc_cidr_block" {
  type        = string
  description = "vpc ip range"
  default     = "10.0.0.0/16"
}

variable "env" {
  type        = string
  description = "environment name"
  default     = "dev"
}

variable "support_vpc_dns" {
  type        = bool
  description = "enable dns support in vpc"
  default     = true
}

variable "support_vpc_hostname" {
  type        = bool
  description = "nable hostname support in vpc"
  default     = true
}

###########################
# Availability Zones
###########################

variable "azs" {
  description = "availability zones for subnets"
  type        = list(string)
}

###########################
# Subnets
###########################

variable "private_subnets" {
  description = "CIDR range for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  description = "CIDR range for public subnets"
  type        = list(string)
  default     = ["10.0.5.0/24", "10.0.6.0/24"]
}

variable "private_subnet_tags" {
  description = "Name tags for private subnets"
  type        = map(any)
  default     = {}
}

variable "public_subnet_tags" {
  description = "Name tags for public subnets"
  type        = map(any)
  default     = {}
}