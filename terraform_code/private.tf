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
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.cidr_block}"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["${var.cidr_block}"]
    }

    egress {
        from_port = -1
        to_port = -1
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    

    vpc_id = "${aws_vpc.default.id}"

    
}

resource "aws_instance" "private-app-1" {
    ami = "${var.ami_id}"
    availability_zone = "us-east-2a"    
    instance_type = "m1.small"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.private_sg.id}"]
    subnet_id = "${aws_subnet.private.id}"
    source_dest_check = false

    
}
