provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "ec2" {
    ami = "ami-0912f71e06545ad88"
    instance_type = "t2.micro"
    tags = {
        Name = "Terraform EC2 Instance"
    }
}

resource "aws_eip" "eip" {
    instance = aws_instance.ec2.id
    tags = {
        Name = "Terraform EIP"
    }
}

output "EIP" {
    value = aws_eip.eip.public.ip
}