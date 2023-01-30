# VPC

resource "aws_vpc" "myvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "myvpc01"
  }
}

#Internet Gateway

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "IGW"
  }
}

#public subnet

resource "aws_subnet" "public-subnet1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.availability_zone1
  map_public_ip_on_launch = true

  tags = {
    Name = "publicsublet01"
  }
}

resource "aws_subnet" "public-subnet2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = var.availability_zone2
  map_public_ip_on_launch = true

  tags = {
    Name = "publicsublet02"
  }
}


resource "aws_subnet" "public-subnet3" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = var.availability_zone3
  map_public_ip_on_launch = true

  tags = {
    Name = "publicsublet03"
  }
}

#public route table

resource "aws_route_table" "publicroute01" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }
  tags = {
    Name = "publicRoute01"
  }
}

#public route table association 

resource "aws_route_table_association" "public-route-association1" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.publicroute01.id
}

resource "aws_route_table_association" "public-route-association2" {
  subnet_id      = aws_subnet.public-subnet2.id
  route_table_id = aws_route_table.publicroute01.id

}
resource "aws_route_table_association" "public-route-association3" {
  subnet_id      = aws_subnet.public-subnet3.id
  route_table_id = aws_route_table.publicroute01.id
}


#private subnet

resource "aws_subnet" "private-subnet1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = var.availability_zone1
  map_public_ip_on_launch = false

  tags = {
    Name = "PrivateSubnet01"
  }
}

resource "aws_subnet" "private-subnet2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.5.0/24"
  availability_zone       = var.availability_zone2
  map_public_ip_on_launch = false

  tags = {
    Name = "PrivateSubnet02"
  }
}

resource "aws_subnet" "private-subnet3" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.6.0/24"
  availability_zone       = var.availability_zone3
  map_public_ip_on_launch = false

  tags = {
    Name = "PrivateSubnet03"
  }
}

#private route table & subnet association

resource "aws_route_table" "privateroute1" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw1.id
  }
  tags = {
    Name = "privateRoute01"
  }
}


resource "aws_route_table_association" "private-route-association1" {
  subnet_id      = aws_subnet.private-subnet1.id
  route_table_id = aws_route_table.privateroute1.id
}

resource "aws_route_table" "privateroute2" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw2.id
  }
  tags = {
    Name = "privateRoute02"
  }
}


resource "aws_route_table_association" "private-route-association2" {
  subnet_id      = aws_subnet.private-subnet2.id
  route_table_id = aws_route_table.privateroute2.id
}


resource "aws_route_table" "privateroute3" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw3.id
  }
  tags = {
    Name = "privateRoute03"
  }
}



resource "aws_route_table_association" "private-route-association3" {
  subnet_id      = aws_subnet.private-subnet3.id
  route_table_id = aws_route_table.privateroute3.id
}



#Nat gateway

resource "aws_nat_gateway" "gw1" {
  allocation_id = aws_eip.nat_gw_eip1.id
  subnet_id     = aws_subnet.public-subnet1.id
}

resource "aws_nat_gateway" "gw2" {
  allocation_id = aws_eip.nat_gw_eip2.id
  subnet_id     = aws_subnet.public-subnet2.id
}

resource "aws_nat_gateway" "gw3" {
  allocation_id = aws_eip.nat_gw_eip3.id
  subnet_id     = aws_subnet.public-subnet3.id
}


#elastic IP 

resource "aws_eip" "nat_gw_eip1" {
  vpc = true
}

resource "aws_eip" "nat_gw_eip2" {
  vpc = true
}

resource "aws_eip" "nat_gw_eip3" {
  vpc = true
}

#security group

resource "aws_security_group" "jenkins-sg-2022" {
  name        = var.security_group
  vpc_id      = aws_vpc.myvpc.id
  description = "security group for jenkins"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound rule
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.security_group
  }
}

#ec2
resource "aws_instance" "myFirstInstance" {
  ami                    = var.ami_id
  key_name               = var.key_name
  instance_type          = var.instance_type
  count                  = 1
  subnet_id              = aws_subnet.private-subnet1.id
  vpc_security_group_ids = [aws_security_group.jenkins-sg-2022.id]
  associate_public_ip_address = false
  tags = {
    Name = var.tag_name
  }
}

resource "aws_instance" "myFirstInstance2" {
  ami                    = var.ami_id
  key_name               = var.key_name
  instance_type          = var.instance_type
  count                  = 1
  subnet_id              = aws_subnet.private-subnet1.id
  vpc_security_group_ids = [aws_security_group.jenkins-sg-2022.id]
  associate_public_ip_address  = true
  tags = {
    Name = var.tag_name
}

}