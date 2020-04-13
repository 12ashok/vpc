resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"

  tags = {
      name = "terravpc"
  }
}

resource "aws_subnet" "subnet" {
  count = 2

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = aws_vpc.vpc1.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta" {
  count = 2

  subnet_id      = aws_subnet.subnet.*.id[count.index]
  route_table_id = aws_route_table.rt.id
}
resource "aws_subnet" "subnet1" {
  count = 2

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "10.1.${count.index}.0/26"
  vpc_id            = aws_vpc.vpc1.id
}
resource "aws_nat_gateway" "gw" {
  allocation_id = "{aws_eip.nat.id}"
  subnet_id     = "{aws_subnet.subnet1.id}"

  tags = {
    Name = "gw NAT"
  }
}
