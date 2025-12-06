
#######################################################
# VPC MODULE
#######################################################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr

  azs = [
    "${var.aws_region}a",
    "${var.aws_region}b",
    "${var.aws_region}c",
  ]

  public_subnets = [
    "10.10.1.0/24",
    "10.10.2.0/24",
    "10.10.3.0/24",
  ]

  private_subnets = [
    "10.10.11.0/24",
    "10.10.12.0/24",
    "10.10.13.0/24",
  ]

  enable_nat_gateway = true
}
