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
    vpc_security_group_ids = [aws_security_group.all-80.id]
    user_data = <<-EOF
                yum update -y
                yum install httpd -y
                systemctl start httpd
                systemctl enable httpd
                EOF
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
    availability_zones = ["ap-southeat-1"]
    desired_capacity = 1
    min_size = 1
    max_size = 1
    launch_template {
        id = aws_launch_template.web-scaling.id
        version = "$Latest"
    }
}
