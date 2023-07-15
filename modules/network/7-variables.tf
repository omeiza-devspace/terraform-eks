###########################
# VPC
###########################
variable "vpc_cidr" {
  type        = string
  description = "vpc ip range"
}

variable "env" {
  type        = string
  description = "environment name"
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

variable "private_subnet_cidrs" {
  description = "CIDR range for private subnets"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR range for public subnets"
  type        = list(string)
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