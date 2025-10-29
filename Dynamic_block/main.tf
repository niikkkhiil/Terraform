provider "aws" {
  region = "ap-south-1"
}

variable "ingressrules" {
    type = list(number)
    default = [ 80, 443 ]
}

variable "egressrules" {
    type = list(number)
    default = [ 80,443,20,3306 ]
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

    dynamic "ingress" {
        iterator = port
        for_each = var.ingressrules
        content {
          from_port = port.value
          to_port = port.value
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
        
    }
    
    dynamic "egress"  {
        iterator = port
        for_each = var.egressrules
        content {
          from_port = port.value
          to_port = port.value
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
        
    }
    tags = {
        Name = "terraform_dynamic_sg"
    }
}