
provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "gergo-eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.7.0"

  name                 = "gergo-eks-vpc"
  cidr                 = var.vpc_cidr
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}

resource "aws_vpc" "gergo-eks-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "gergo-eks-vpc"
  }
}

resource "aws_internet_gateway" "gergo-igw" {
  vpc_id = aws_vpc.gergo-eks-vpc.id

  tags = {
    Name = "gergo-igw"
  }
}

resource "aws_subnet" "priv-1" {
  vpc_id     = aws_vpc.gergo-eks-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "priv-1"
  }
}

resource "aws_nat_gateway" "gergo-single-natgw" {
  allocation_id = aws_eip.example.id
  subnet_id     = aws_subnet.priv-1.id

  tags = {
    Name = "gergo-single-natgw"
  }

  depends_on = [aws_internet_gateway.example]
}