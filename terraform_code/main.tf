provider "aws" {
      region     = "${var.region}"
      shared_credentials_file = "/home/ubuntu/.aws/creds"
      profile = "default"
}


# VPC resources: This will create 1 VPC with 4 Subnets, 1 Internet Gateway, 4 Route Tables. 

resource "aws_vpc" "default" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
}

resource "aws_route_table" "private" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id = aws_vpc.default.id
}

resource "aws_route" "private" {
  count = length(var.private_subnet_cidr_blocks)

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.default[count.index].id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id            = aws_vpc.default.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr_blocks)

  vpc_id                  = aws_vpc.default.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr_blocks)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr_blocks)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


# NAT resources: This will create 2 NAT gateways in 2 Public Subnets for 2 different Private Subnets.

resource "aws_eip" "nat" {
  count = length(var.public_subnet_cidr_blocks)

  vpc = true
}

resource "aws_nat_gateway" "default" {
  depends_on = ["aws_internet_gateway.default"]

  count = length(var.public_subnet_cidr_blocks)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
}
 


/*
  Web Servers
*/
resource "aws_security_group" "public_sg" {
    name = "vpc_sg"
    description = "Allow incoming HTTP connections."

    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.default.id}"

    
}

resource "aws_instance" "public-app-1" {
    count = length(var.public_subnet_cidr_blocks)
    ami = "${var.ami_id}"
    availability_zone = "us-east-2a"
    instance_type = "m1.small"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.public_sg.id}"]
    subnet_id = aws_subnet.public[count.index].id
    associate_public_ip_address = true
    source_dest_check = false
    

}

resource "aws_eip" "public-app-1" {
    count = length(var.public_subnet_cidr_blocks)
    instance =aws_instance.public-app-1[count.index].id
    vpc = true
}




/*
  Private Servers
*/
resource "aws_security_group" "private_sg" {
    name = "vpc_db"
    description = "Allow incoming database connections."

    ingress { # SQL Server
        from_port = -1
        to_port = -1
        protocol = "tcp"
        security_groups = ["${aws_security_group.public_sg.id}"]
    }
    
    ingress {
        from_port = -1
        to_port = -1
        protocol = "tcp"
        cidr_blocks = ["${var.cidr_block}"]
    }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
    

    vpc_id = "${aws_vpc.default.id}"

    
}

resource "aws_instance" "private-app-1" {
    count = length(var.private_subnet_cidr_blocks)
    ami = "${var.ami_id}"
    availability_zone = "us-east-2a"    
    instance_type = "m1.small"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.private_sg.id}"]
    subnet_id = aws_subnet.private[count.index].id
    source_dest_check = false

    
}

