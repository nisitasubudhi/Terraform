resource "aws_subnet" "public-subnet-1" {
  vpc_id     = aws_vpc.demovpc.id
  cidr_block = "10.0.0.0/28"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "public-subnet-1"
  }
}
resource "aws_subnet" "public-subnet-2" {
  vpc_id     = aws_vpc.demovpc.id
 cidr_block = "10.0.0.16/28"
  availability_zone       = "us-east-1b"
  tags = {
Name = "public-subnet-2"
  }
}
resource "aws_subnet" "application-subnet-1" {
  vpc_id     = aws_vpc.demovpc.id
  cidr_block = "10.0.0.32/28"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "application-subnet-1"
}
}
resource "aws_subnet" "application-subnet-2" {
  vpc_id     = aws_vpc.demovpc.id
  cidr_block = "10.0.0.48/28"
  availability_zone       = "us-east-1b"
  tags = {
    Name = "application-subnet-2"
  }
}
resource "aws_subnet" "database-subnet-1" {
  vpc_id     = aws_vpc.demovpc.id
  cidr_block = "10.0.0.64/28"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "database-subnet-1"
  }
}
resource "aws_subnet" "database-subnet-2" {
  vpc_id     = aws_vpc.demovpc.id
  cidr_block = "10.0.0.80/28"
  availability_zone       = "us-east-1b"
  tags = {
    Name = "database-subnet-2"
  }
}
