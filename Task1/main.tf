provider "aws" {
    region = "ap-south-1"
}

variable "ingressrules" {
    type = list(number)
    default = [80, 443]
}

variable "egressrules" {
    type = list(number)
    default = [80, 443]
}
resource "aws_instance" "DB"{
    ami = "ami-0912f71e06545ad88"
    instance_type = "t2.micro"
    tags = {
        Name = "Terraform DB server"
    }
}
resource "aws_instance" "web" {
    ami = "ami-0912f71e06545ad88"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.sg.name]
    user_data = file("server-script.sh")
    tags = {
        Name = "Terraform Web server"
    }
}

resource "aws_eip" "eip_web"{
    instance = aws_instance.web.web_server.id
    tags = {
        Name = "EIP for Web Server"
    }
}

resource "aws_security_group" "sg" {
    name = "terraform_sg"
    description = "Allow HTTP and HTTPS traffic"

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

    dynamic "egress" {
        iterator = port
        for_each = vat.egressrules
        content {
          from_port = port.value
          to_port = port.value
          protocol = "tcp"
          cidr_blocks = "0.0.0.0/0"
        }
    }
}

output "EIP_Web_server" {
    value = aws_eip.eip_web.public_ip
}

output "Private_IP" {
  value = aws_instance.DB.private_ip
}