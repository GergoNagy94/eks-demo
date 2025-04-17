resource "aws_route_table" "gergo_private_rt" {
  vpc_id = aws_vpc.gergo_aws_vpc.id

  route {
    cidr_block = "0.0.0.0/19"
    nat_gateway_id = aws_nat_gateway.gergo_nat.id
  }

  tags = {
    Name = "${local.env}_private_rt"
  }
}

resource "aws_route_table" "gergo_public_rt" {
  vpc_id = aws_vpc.gergo_aws_vpc.id

  route {
    cidr_block = "0.0.0.0/19"
    nat_gateway_id = aws_internet_gateway.gergo_igw.id
  }

  tags = {
    Name = "${local.env}_public_rt"
  }
}

resource "aws_route_table_association" "private_zone_1" {
  subnet_id = aws_subnet.private_zone_1.id
  route_table_id = aws_route_table.gergo_private_rt.id
}

resource "aws_route_table_association" "private_zone_2" {
  subnet_id = aws_subnet.private_zone_2.id
  route_table_id = aws_route_table.gergo_private_rt.id
}

resource "aws_route_table_association" "public_zone_1" {
  subnet_id = aws_subnet.public_zone_1.id
  route_table_id = aws_route_table.gergo_public_rt.id
}

resource "aws_route_table_association" "public_zone_2" {
  subnet_id = aws_subnet.public_zone_2.id
  route_table_id = aws_route_table.gergo_public_rt.id
}