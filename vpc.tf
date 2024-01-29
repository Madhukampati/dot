resource "aws_vpc" "vpc-1" {
  cidr_block = var.cidr_block
  tags = {
    Name = "aws-1"
  }
}
resource "aws_subnet" "subnet-public" {
  count = 3
  vpc_id            = aws_vpc.vpc-1.id
  cidr_block        = "${element(var.subnet1,count.index)}"
  availability_zone = "${element(var.az1,count.index)}"
  tags = {
    Name = "${var.subnet1_name}-1.$(count.index)"
  }
}

resource "aws_subnet" "subnet-private" {
  count = 2
  vpc_id            = aws_vpc.vpc-1.id
  cidr_block        = "${element(var.subnet2,count.index)}"
  availability_zone = "${element(var.az1,count.index)}"

  tags = {
    Name = "${var.subnet2_name}-1.$(count.index)"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc-1.id
  tags = {
    Name = "${var.igw_name}-igw"
  }
}

resource "aws_route_table" "rt3" {
  vpc_id = aws_vpc.vpc-1.id
  tags = {
    Name = "${var.rt_name}-rt1.$(count.index)"
  }
  # since this is exactly the route AWS will create, the route will be adopted
  route {
    cidr_block = var.cidr_block
    gateway_id = "local"
  }
}
resource "aws_route_table" "rt4"{
  vpc_id = aws_vpc.vpc-1.id
  tags = {
    Name = "$(var.rt_name)-rt2.$(count.index)"
  }

}

resource "aws_security_group" "allow_tls" {
  name   = "allow"
  vpc_id = aws_vpc.vpc-1.id
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "sg-2"
  }
}

