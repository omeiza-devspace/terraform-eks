# get all available AZs in our region
data "aws_availability_zones" "available_azs" {
  state = "available"
}

# used for accesing Account ID and ARN
data "aws_caller_identity" "current" {}

