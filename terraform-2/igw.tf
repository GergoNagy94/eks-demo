resource "aws_internet_gateway" "gergo_igw" {
  vpc_id = aws_vpc.gergo_aws_vpc.id

  tags = {
    Name = "${local.env}_gergo_igw"
  }
}