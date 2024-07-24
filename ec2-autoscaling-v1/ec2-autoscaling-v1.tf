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

resource "aws_launch_template" "web-scaling" {
    name = "web-scaling"
    image_id = var.image_id
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.all-80.id]
    user_data = "${base64encode(data.template_file.userdata.rendered)}"
}
resource "aws_security_group" "all-80" {
    name = "all-80"
    vpc_id = var.main
}
resource "aws_vpc_security_group_ingress_rule" "ingress-80" {
    security_group_id = aws_security_group.all-80.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = var.http-port
    to_port = var.http-port
    ip_protocol = "tcp"
}

resource "aws_autoscaling_group" "web-auto" {
    availability_zones = ["ap-southeast-1a"]
    desired_capacity = 1
    min_size = 1
    max_size = 1
    launch_template {
        id = aws_launch_template.web-scaling.id
        version = "$Latest"
    }
}

data "template_file" "userdata" {
  template = <<-EOF
                #!/bin/bash
                yum update
                yum install httpd -y
                systemctl start httpd
                systmectl enable httpd
                EOF
}