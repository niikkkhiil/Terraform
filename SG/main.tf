provider "aws" {
  region = "ap-south-1"
}

resource "ec2_instance" "ec2" {
    ami = "ami-0912f71e06545ad88"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.sg.name]
    tags = {
        Name = "Terraform EC2 Instance"
    }
}

resource "aws_security_group" "sg" {
    name = "terraform_sg"
    description = "Allow HTTP traffic"

    ingress = {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress = {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "terraform_sg"
    }
}