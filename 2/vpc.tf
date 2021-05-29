# VPC
resource "aws_vpc" "ocft-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name    = "ocft-vpc"
    Env = "development"
  }
}


# Subnets
resource "aws_subnet" "ocft-subnet-pub-a" {
  vpc_id            = aws_vpc.ocft-vpc.id
  cidr_block        = "10.0.0.0/25"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name    = "ocft-subnet-pub-a"
    Env = "development"
  }
}

resource "aws_subnet" "ocft-subnet-pub-b" {
  vpc_id            = aws_vpc.ocft-vpc.id
  cidr_block        = "10.0.0.128/25"
  availability_zone = "ap-northeast-2b"

  tags = {
    Name    = "ocft-subnet-pub-b"
    Env = "development"
  }
}

resource "aws_subnet" "ocft-subnet-priv-a" {
  vpc_id            = aws_vpc.ocft-vpc.id
  cidr_block        = "10.0.1.0/25"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name    = "ocft-subnet-priv-a"
    Env = "development"
  }
}

resource "aws_subnet" "ocft-subnet-priv-b" {
  vpc_id            = aws_vpc.ocft-vpc.id
  cidr_block        = "10.0.1.128/25"
  availability_zone = "ap-northeast-2b"

  tags = {
    Name    = "ocft-subnet-priv-b"
    Env = "development"
  }
}

#IGW
resource "aws_internet_gateway" "ocft-igw" {
  vpc_id = aws_vpc.ocft-vpc.id

  tags = {
    Name    = "ocft-igw"
    Env = "development"
  }
}


#NAT elastic IP
resource "aws_eip" "ocft-nat-ip-a" {
  vpc = true

  tags = {
    Name    = "ocft-nat-a"
    Env = "development"
  }
}

resource "aws_eip" "ocft-nat-ip-b" {
  vpc = true

  tags = {
    Name    = "ocft-nat-b"
    Env = "development"
  }
}

# NAT
resource "aws_nat_gateway" "ocft-nat-a" {
  allocation_id = aws_eip.ocft-nat-ip-a.id
  subnet_id     = aws_subnet.ocft-subnet-pub-a.id
  depends_on    = [aws_eip.ocft-nat-ip-a]
}

resource "aws_nat_gateway" "ocft-nat-b" {
  allocation_id = aws_eip.ocft-nat-ip-b.id
  subnet_id     = aws_subnet.ocft-subnet-pub-b.id
  depends_on    = [aws_eip.ocft-nat-ip-b]

}

# Route table
resource "aws_route_table" "ocft-rt-pub-a" {
  vpc_id = aws_vpc.ocft-vpc.id

  route {
    # associated subnet can reach everywhere
    cidr_block = "0.0.0.0/0"
    # CRT uses this IGW to reach internet
    gateway_id = aws_internet_gateway.ocft-igw.id
  }

  tags = {
    Name = "ocft-rt-pub-a"
     Env = "development"
  }

}

resource "aws_route_table" "ocft-rt-pub-b" {
  vpc_id = aws_vpc.ocft-vpc.id

  route {
    # associated subnet can reach everywhere
    cidr_block = "0.0.0.0/0"
    # CRT uses this IGW to reach internet
    gateway_id = aws_internet_gateway.ocft-igw.id
  }

  tags = {
    Name = "ocft-rt-pub-b"
    Env = "development"
  }
}

resource "aws_route_table" "ocft-rt-priv-a" {
  vpc_id = aws_vpc.ocft-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ocft-nat-a.id
  }


  tags = {
    Name = "ocft-rt-priv-a"
    Env = "development"
  }
}

resource "aws_route_table" "ocft-rt-priv-b" {
  vpc_id = aws_vpc.ocft-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ocft-nat-b.id
  }


  tags = {
    Name = "ocft-rt-priv-b"
    Env = "development"
  }
}


# RT Association
resource "aws_route_table_association" "ocft-rta-pub-a"{
    subnet_id = aws_subnet.ocft-subnet-pub-a.id
    route_table_id = aws_route_table.ocft-rt-pub-a.id
    depends_on = [
        aws_route_table.ocft-rt-pub-a,
        aws_subnet.ocft-subnet-pub-a
    ]
}

resource "aws_route_table_association" "ocft-rta-pub-b"{
    subnet_id = aws_subnet.ocft-subnet-pub-b.id
    route_table_id = aws_route_table.ocft-rt-pub-b.id
    depends_on = [
        aws_route_table.ocft-rt-pub-b,
        aws_subnet.ocft-subnet-pub-b
    ]
}

resource "aws_route_table_association" "ocft-rta-priv-a"{
    subnet_id = aws_subnet.ocft-subnet-priv-a.id
    route_table_id = aws_route_table.ocft-rt-priv-a.id
    depends_on = [
        aws_route_table.ocft-rt-priv-a,
        aws_subnet.ocft-subnet-priv-a
    ]
}

resource "aws_route_table_association" "ocft-rta-priv-b"{
    subnet_id = aws_subnet.ocft-subnet-priv-b.id
    route_table_id = aws_route_table.ocft-rt-priv-b.id
    depends_on = [
        aws_route_table.ocft-rt-priv-b,
        aws_subnet.ocft-subnet-priv-b
    ]
}