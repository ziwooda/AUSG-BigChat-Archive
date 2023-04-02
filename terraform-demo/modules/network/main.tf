#############################
# vpc
resource "aws_vpc" "demo_vpc" {
  cidr_block       = "${var.vpc_cidr}"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.env}-${var.tag}-vpc"
  }
}

#################################
# public subnet for bastion host
resource "aws_subnet" "public_subnet" {
  count = "${length(var.azs)}"
  vpc_id = aws_vpc.demo_vpc.id
  availability_zone = "${element(var.azs, count.index)}"
  cidr_block = "${cidrsubnet(var.vpc_cidr, 8, count.index+1)}"
  map_public_ip_on_launch = true
  
  tags = { 
    Name = "${var.env}-${var.tag}-pub-subnet${count.index+1}"
  }
}

# private subnet
resource "aws_subnet" "private_subnet" {
  count = "${length(var.azs)}"
  vpc_id = aws_vpc.demo_vpc.id
  availability_zone = "${element(var.azs, count.index)}"
  cidr_block = "${cidrsubnet(var.vpc_cidr, 8, count.index+11)}"
  
  tags = { 
    Name = "${var.env}-${var.tag}-pri-subnet${count.index+1}"
  }
}

#############################
# internet gateway
resource "aws_internet_gateway" "demo_igw" {
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    Name = "${var.env}-${var.tag}-igw"
  }
}

#############################
# eip for ngw
resource "aws_eip" "demo_eip" {
  vpc      = true
  depends_on = [
    aws_internet_gateway.demo_igw
  ]

  tags = {
    Name = "${var.env}-${var.tag}-eip"
  }
}

# nat gateway
resource "aws_nat_gateway" "demo_ngw" {
  allocation_id = aws_eip.demo_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "${var.env}-${var.tag}-nat"
  }

  depends_on = [aws_internet_gateway.demo_igw]
}

#############################
# route table & association
resource "aws_route_table" "demo_pub_rt" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_igw.id
  }

  tags = {
    Name = "${var.env}-${var.tag}-pub-rt"
  }
}

resource "aws_route_table" "demo_pri_rt" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.demo_ngw.id
  }

  tags = {
    Name = "${var.env}-${var.tag}-pri-rt"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.azs)
  subnet_id = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = aws_route_table.demo_pub_rt.id
}

resource "aws_route_table_association" "web_private" {
  count = "${length(var.azs)}"
  subnet_id = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  route_table_id = aws_route_table.demo_pri_rt.id
}