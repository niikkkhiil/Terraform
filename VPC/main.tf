provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "main"{
  cidr_block = "192.168.0.0/24"
  tags={
    Name = "terraform_vpc"
    }
}