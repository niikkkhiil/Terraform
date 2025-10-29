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