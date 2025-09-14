resource "aws_vpc" "product_v1" {
  cidr_block       = "125.22.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "product-v1"
  }
}

resource "aws_subnet" "product_v1_subnet_1a_public" {
  vpc_id                  = aws_vpc.product_v1.id
  cidr_block              = "125.22.1.0/28"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "product-v1-subnet-1a-public"
  }
}

resource "aws_subnet" "product_v1_subnet_1b_public" {
  vpc_id                  = aws_vpc.product_v1.id
  cidr_block              = "125.22.2.0/28"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "product-v1-subnet-1b-public"
  }
}


resource "aws_subnet" "product_v1_subnet_1c_private" {
  vpc_id            = aws_vpc.product_v1.id
  cidr_block        = "125.22.3.0/28"
  availability_zone = "ap-south-1c"

  tags = {
    Name = "product-v1-subnet-1c-private"
  }
}


resource "aws_subnet" "product_v1_subnet_1d_private" {
  vpc_id            = aws_vpc.product_v1.id
  cidr_block        = "125.22.4.0/28"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "product-v1-subnet-1d-private"
  }
}


#######################################################################################
#internet gate way

resource "aws_internet_gateway" "product_v1_igw" {
  vpc_id = aws_vpc.product_v1.id

  tags = {
    Name = "product-v1-igw"
  }
}

#route table 1

  resource "aws_route_table" "product_v1_rt" {
    vpc_id = aws_vpc.product_v1.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.product_v1_igw.id

    }

    tags = {
      Name = "product-v1-rt"
    }
  }


 resource "aws_route_table_association" "product_v1_rt_assoc_1a_3"{
  for_each = {
    subnet1 = aws_subnet.product_v1_subnet_1a_public.id
    subnet2 = aws_subnet.product_v1_subnet_1b_public.id
  }
  subnet_id = each.value
  route_table_id = aws_route_table.product_v1_rt.id


 }




#creating eip for nat gw

resource "aws_eip" "product_v1_eip" {
  domain = "vpc"
  tags = {
    Name = "product-v1-eip"
  }
}

resource "aws_nat_gateway" "product_v1_nat_gw" {
  allocation_id = aws_eip.product_v1_eip.id
  subnet_id    = aws_subnet.product_v1_subnet_1a_public.id

  tags = {
    Name = "product-v1-nat-gw"
  }

  depends_on = [aws_internet_gateway.product_v1_igw]
}

# route table 2
  resource "aws_route_table" "product_v1_rt_2" {
    vpc_id = aws_vpc.product_v1.id

    route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.product_v1_nat_gw.id
    }

    tags = {
      Name = "product-v1-rt-2"
    }
  }

resource "aws_route_table_association" "product_v1_rt_assoc_1c" {
for_each = {
   subnet3=aws_subnet.product_v1_subnet_1c_private.id
   subnet4=aws_subnet.product_v1_subnet_1d_private.id
}
  subnet_id      = each.value
  route_table_id = aws_route_table.product_v1_rt_2.id
}

#############################################################################

#nacl groups for each subnets
resource "aws_network_acl" "product_v1_nacl_1" {
  vpc_id = aws_vpc.product_v1.id

  tags = {
    Name = "product-v1-nacl-1"
  }
}

resource "aws_nacl_rule" "product_v1_nacl_1_inbound_http" {
  network_acl_id = aws_network_acl.product_v1_nacl_1.id
  rule_number    = 100
  egress         = false
  protocol       = "6" # TCP
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource "aws_nacl_rule" "product_v1_nacl_1_outbound_http" {
  network_acl_id = aws_network_acl.product_v1_nacl_1.id
  rule_number    = 100
  egress         = true
  protocol       = "6" # TCP
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"  
  from_port      = 80
  to_port        = 80
}


#security group 
resource "aws_security_group" "product_v1_sg"{

  name        = "product-v1-sg"
  description = "Allow HTTP, HTTPS and SSH"
  vpc_id      = aws_vpc.product_v1.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

# ALB Security Group
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = aws_vpc.product_v1.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-security-group"
  }
}




