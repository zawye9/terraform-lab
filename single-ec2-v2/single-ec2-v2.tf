terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.59.0"
    }
  }
}
provider "aws" {
    region = "ap-southeast-1"
}

resource aws_instance "web" {
    ami = "ami-0e97ea97a2f374e3d"
    instance_type = "t2.micro"
    user_data = <<-EOF
                #!/bin/bash
                yum update
                yum install httpd -y
                systemctl start httpd
                systmectl enable httpd
                EOF
    tags = {
        name = "web"
    }
}

resource "aws_security_group" "all-8080" {
    name = "all-8080"
    vpc_id = var.main
}
resource "aws_vpc_security_group_ingress_rule" "ingress" {
    security_group_id = aws_security_group.all-8080.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = var.http-port
    to_port = var.http-port
    ip_protocol = "tcp"
}