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

    egress { # SQL Server
        from_port = -1
        to_port = -1
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.default.id}"

    tags {
        Name = "Public SG"
    }
}

resource "aws_instance" "public-app-1" {
    ami = "${var.ami_id}"
    availability_zone = "us-east-2a"
    instance_type = "m1.small"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.public_sg.id}"]
    subnet_id = "${aws_subnet.public.id}"
    associate_public_ip_address = true
    source_dest_check = false
    
    

    tags {
        Name = "Public App 1"
    }
}

resource "aws_eip" "public-app-1" {
    instance = "${aws_instance.public-app-1.id}"
    vpc = true
}