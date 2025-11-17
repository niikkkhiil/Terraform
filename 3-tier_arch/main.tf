provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "terraform_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "terraform_vpc"  
    }
  
}

resource "aws_subnet" "vpc_subnet1" {
    vpc_id = aws_vpc.terraform_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-south-1a"
    tags = {
        Name = "terraform_subnet_public"
    }
}

resource "aws_subnet" "vpc_subnet2" {
    vpc_id = aws_vpc.terraform_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "ap-south-1a"
    tags = {
        Name = "terraform_subnet_private"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.terraform_vpc.id
    tags = {
        Name = "terraform_igw"
    }
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.terraform_vpc.id
    tags = {
        Name = "terraform_public_rt"
    }
}

resource "aws_route" "public_route" {
    route_table_id = aws_route_table.public_rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_rt_assoc" {
    subnet_id = aws_subnet.vpc_subnet1.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.terraform_vpc.id
    tags = {
        Name = "terraform_private_rt"
    }
}
resource "aws_route_table_association" "private_rt_assoc" {
    subnet_id = aws_subnet.vpc_subnet2.id
    route_table_id = aws_route_table.private_rt.id
}

resource "aws_nat_gateway" "nat_gw" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.vpc_subnet1.id
    tags = {
        Name = "terraform_nat_gw"
    }
}

resource "aws_eip" "nat_eip" {
    domain = "vpc"
    tags = {
        Name = "terraform_nat_eip"
    }
}

resource "aws_route" "private_route" {
    route_table_id = aws_route_table.private_rt.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
}

# Security Groups
resource "aws_security_group" "web_sg" {
    name = "web-tier-sg"
    vpc_id = aws_vpc.terraform_vpc.id
    
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "app_sg" {
    name = "app-tier-sg"
    vpc_id = aws_vpc.terraform_vpc.id
    
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        security_groups = [aws_security_group.web_sg.id]
    }
    
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "db_sg" {
    name = "db-tier-sg"
    vpc_id = aws_vpc.terraform_vpc.id
    
    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = [aws_security_group.app_sg.id]
    }
}

# Web Tier
resource "aws_instance" "web" {
    ami = "ami-0912f71e06545ad88"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.vpc_subnet1.id
    vpc_security_group_ids = [aws_security_group.web_sg.id]
    associate_public_ip_address = true
    
    tags = {
        Name = "Web-Server"
    }
}

# App Tier
resource "aws_instance" "app" {
    ami = "ami-0912f71e06545ad88"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.vpc_subnet2.id
    vpc_security_group_ids = [aws_security_group.app_sg.id]
    
    tags = {
        Name = "App-Server"
    }
}

# Database Tier 
resource "aws_instance" "database" {
    ami = "ami-0912f71e06545ad88"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.vpc_subnet2.id
    vpc_security_group_ids = [aws_security_group.db_sg.id]
    
    tags = {
        Name = "Database-Server"
    }
}

