# ------- networking/main.tf

data "aws_availability_zones" "available" {}

resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "aws_vpc" "Week21_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Week21_vpc-${random_integer.random.id}"
  }
}

#Public subnets
resource "aws_subnet" "lu_public_subnets" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.Week21_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "lu_public_subnet_${count.index + 1}"
  }
}

#Associate public subnets with routing table
resource "aws_route_table_association" "lu_Public_assoc" {
  count          = var.public_subnet_count
  subnet_id      = aws_subnet.lu_public_subnets.*.id[count.index]
  route_table_id = aws_route_table.lu_public_rt.id
}

#Private subnets
resource "aws_subnet" "lu_private_subnets" {
  count                   = var.private_subnet_count
  vpc_id                  = aws_vpc.Week21_vpc.id
  cidr_block              = var.private_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "lu_private_subnet_${count.index + 1}"
  }
}

#Internet gateway
resource "aws_internet_gateway" "lu_igw" {
  vpc_id = aws_vpc.Week21_vpc.id

  tags = {
    Name = "lu_IGW"
  }
}

#NAT Gateway
resource "aws_eip" "nat_gw" {}

resource "aws_nat_gateway" "my_NATgw" {
  allocation_id = aws_eip.nat_gw.id
  subnet_id     = aws_subnet.lu_public_subnets[1].id

  tags = {
    Name = "lu_NAT_gw"
  }
}

#Route Table for Public Subnets
resource "aws_route_table" "lu_public_rt" {
  vpc_id = aws_vpc.Week21_vpc.id

  tags = {
    Name = "lu_public_rt"
  }
}

resource "aws_default_route_table" "default_public_rt" {
  default_route_table_id = aws_vpc.Week21_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lu_igw.id
  }
}

#Route Table for Private Subnets
resource "aws_route_table" "lu_private_rt" {
  vpc_id = aws_vpc.Week21_vpc.id

  tags = {
    Name = "lu_private_rt"
  }
}

resource "aws_default_route_table" "default_private_rt" {
  default_route_table_id = aws_vpc.Week21_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my_NATgw.id
  }
}

#Create Security group
resource "aws_security_group" "bastion_pub_sg" {
  name        = "bastion_pub_sg"
  description = "Security group to allow inbound traffic to bastion host"
  vpc_id      = aws_vpc.Week21_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.access_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "webserver_priv_sg" {
  name        = "webserver_priv_sg"
  description = "HTTP traffic from lb and SSH traffic from bastion host"
  vpc_id      = aws_vpc.Week21_vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_pub_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "lb_sg" {
  name        = "lb_sg"
  description = "Security group to allow inbound HTTP traffic"
  vpc_id      = aws_vpc.Week21_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}