# ------- networking/main.tf

data "aws_availability_zones" "available" {}

resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "aws_vpc" "Week21_vpc" {
  cidr_block       = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Week21_vpc-${random_integer.random.id}"
  }
}

#Public subnets
resource "aws_subnet" "lu-public_subnet" {
  count = var.public_subnet_count
  vpc_id                  = aws_vpc.Week21_vpc.id
  cidr_block             = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "lu-public_subnet_${count.index + 1}"
  }
}

#Associate public subnets with routing table
resource "aws_route_table_association" "lu_Public_assoc" {
  count = var.public_subnet_count
  subnet_id      = aws_subnet.lu-public_subnet.*.id[count.index]
  route_table_id = aws_route_table.lu_public_rt.id
}

#Private subnets
resource "aws_subnet" "lu-private_subnet" {
  count = var.private_subnet_count
  vpc_id                  = aws_vpc.Week21_vpc.id
  cidr_block             = var.private_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "lu-private_subnet_${count.index + 1}"
  }
}

#Create Internet gateway
resource "aws_internet_gateway" "lu_internet_gateway" {
  vpc_id = aws_vpc.Week21_vpc.id

  tags = {
    Name = "lu_IGW"
  }
}

#Create Route Table for Public Subnets
resource "aws_route_table" "lu_public_rt" {
  vpc_id = aws_vpc.Week21_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lu_internet_gateway.id
  }

  tags = {
    Name = "lu_public"
  }
}

resource "aws_default_route_table" "lu_private_rt" {
  default_route_table_id =  aws_vpc.Week21_vpc.default_route_table_id
}

#Create Security group
resource "aws_security_group" "lu_sg" {
  name        = "public_sg"
  description = "Security group for public access"
  vpc_id      = aws_vpc.Week21_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.access_ip]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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