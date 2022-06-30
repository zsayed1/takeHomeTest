// Create vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = var.environment
  }
}

// Create subnet a
resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr_a
  availability_zone = "${var.region}a"
  tags = {
    Name = "subnet_a" // Could use variables, sticking to hard code for simplicity
    Type = "public"
  }
}

// Create subnet b
resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr_b
  availability_zone = "${var.region}b"
  tags = {
    Name = "subnet_b"
    Type = "private_nated"
  }
}

// Create subnet c
resource "aws_subnet" "subnet_c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr_c
  availability_zone = "${var.region}c"
  tags = {
    Name = "subnet_c"
    Type = "private_isolated"
  }
}

// Create internet gateway for public access
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
  }
}

// Add public route table to internet gateway
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Route Table for Public Subnet"
  }
}

// Add public route table to public subnets a
resource "aws_route_table_association" "subnet_a_route_table_association" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.public_route_table.id
}

// Add elastic ip for nat gateway
resource "aws_eip" "nat_gw_elasticip" {
  vpc = true

  tags = {
    Name        = "${var.environment}-eip"
    Environment = var.environment
  }
  depends_on = [
    aws_internet_gateway.igw
  ]
}

// Add Nat Gateway for private subnets
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_gw_elasticip.id
  subnet_id     = aws_subnet.subnet_a.id
  tags = {
    Name        = "${var.environment}-nat"
    Environment = var.environment
  }
  depends_on = [
    aws_eip.nat_gw_elasticip
  ]
}

// Add route table for to nat gateway
resource "aws_route_table" "private_route_table_nated" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "Route Table for NAT-ed subnet"
  }
}

// Add route table association for private nated subnet
resource "aws_route_table_association" "subnet_a_route_table_association_nated" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.private_route_table_nated.id
}


resource "aws_route_table" "private_route_table_nated_isolated" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Isolated SUbnet"
  }
}

// Add route table association for private isolated subnet
resource "aws_route_table_association" "my_vpc_us_east_1a_private" {
  subnet_id      = aws_subnet.subnet_c.id
  route_table_id = aws_route_table.private_route_table_nated_isolated.id
}