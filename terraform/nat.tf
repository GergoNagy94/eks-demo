resource "aws_eip" "gergo_eip" {
  domain = "vpc"

  tags = {
    Name = "${local.env}_nat"
  }
}

resource "aws_nat_gateway" "gergo_nat" {
  allocation_id = aws_eip.gergo_eip.id
  subnet_id = aws_subnet.public_zone_1.id

  tags = {
    Name = "${local.env}_nat"
  }

  depends_on = [ aws_internet_gateway.gergo_igw ]
}