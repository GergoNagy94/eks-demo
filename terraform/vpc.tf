resource "aws_vpc" "gergo_aws_vpc" {
  cidr_block = "10.0.0.0/16"

  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.env}_gergo_aws_vpc"
  }
}