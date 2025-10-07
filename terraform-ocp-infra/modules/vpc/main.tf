data "aws_availability_zones" "available" {
  state = "available"
}

# VPC
resource "aws_vpc" "openshift_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-vpc"
  })
}

# Internet Gateway
resource "aws_internet_gateway" "openshift_igw" {
  vpc_id = aws_vpc.openshift_vpc.id

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-igw"
  })
}

# Public Subnets
resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.openshift_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-public-subnet-${count.index + 1}"
    Type = "public"
  })
}

# Private Subnets
resource "aws_subnet" "private_subnets" {
  count = length(var.private_subnet_cidrs)

  vpc_id            = aws_vpc.openshift_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-private-subnet-${count.index + 1}"
    Type = "private"
  })
}

# Elastic IPs for NAT Gateways
resource "aws_eip" "nat_eips" {
  count = length(var.public_subnet_cidrs)

  domain = "vpc"

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-nat-eip-${count.index + 1}"
  })

  depends_on = [aws_internet_gateway.openshift_igw]
}

# NAT Gateways
resource "aws_nat_gateway" "nat_gateways" {
  count = length(var.public_subnet_cidrs)

  allocation_id = aws_eip.nat_eips[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-nat-gw-${count.index + 1}"
  })

  depends_on = [aws_internet_gateway.openshift_igw]
}

# Route Table for Public Subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.openshift_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.openshift_igw.id
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-public-rt"
  })
}

# Route Table Associations for Public Subnets
resource "aws_route_table_association" "public_rta" {
  count = length(aws_subnet.public_subnets)

  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# Route Tables for Private Subnets
resource "aws_route_table" "private_rt" {
  count = length(var.private_subnet_cidrs)

  vpc_id = aws_vpc.openshift_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateways[count.index].id
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-private-rt-${count.index + 1}"
  })
}

# Route Table Associations for Private Subnets
resource "aws_route_table_association" "private_rta" {
  count = length(aws_subnet.private_subnets)

  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
}

# VPC Endpoints for S3
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.openshift_vpc.id
  service_name = "com.amazonaws.${var.aws_region}.s3"
  
  tags = merge(var.common_tags, {
    Name = "${var.project_name}-s3-endpoint"
  })
}

# VPC Endpoint Route Table Associations
resource "aws_vpc_endpoint_route_table_association" "s3_public" {
  route_table_id  = aws_route_table.public_rt.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

resource "aws_vpc_endpoint_route_table_association" "s3_private" {
  count = length(aws_route_table.private_rt)
  
  route_table_id  = aws_route_table.private_rt[count.index].id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}