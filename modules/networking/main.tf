resource "aws_vpc" "main" {
    cidr_block           = "10.0.0.0/16"
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags = {
      Name = "jucr-vpc"
    }
  }
  
  resource "aws_subnet" "public" {
    count                   = 3
    vpc_id                  = aws_vpc.main.id
    cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index)
    availability_zone       = element(["us-east-1a", "us-east-1b", "us-east-1c"], count.index)
    map_public_ip_on_launch = true
    tags = {
      Name = "jucr-public-subnet-${count.index + 1}"
    }
  }
  
  resource "aws_subnet" "private" {
    count             = 3
    vpc_id            = aws_vpc.main.id
    cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index + 10)
    availability_zone = element(["us-east-1a", "us-east-1b", "us-east-1c"], count.index)
    tags = {
      Name = "jucr-private-subnet-${count.index + 1}"
    }
  }
  
  resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    tags = {
      Name = "jucr-igw"
    }
  }
  
  resource "aws_eip" "nat" {
    count = 3
    vpc   = true
  }
  
  resource "aws_nat_gateway" "nat" {
    count         = 3
    allocation_id = aws_eip.nat[count.index].id
    subnet_id     = aws_subnet.public[count.index].id
    tags = {
      Name = "jucr-nat-gateway-${count.index + 1}"
    }
  }
  
  resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
      Name = "jucr-public-rt"
    }
  }
  
  resource "aws_route_table_association" "public" {
    count          = 3
    subnet_id      = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
  }
  
  resource "aws_route_table" "private" {
    count  = 3
    vpc_id = aws_vpc.main.id
    route {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat[count.index].id
    }
    tags = {
      Name = "jucr-private-rt-${count.index + 1}"
    }
  }
  
  resource "aws_route_table_association" "private" {
    count          = 3
    subnet_id      = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private[count.index].id
  }