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