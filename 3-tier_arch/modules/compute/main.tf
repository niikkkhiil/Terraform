resource "aws_instance" "web" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = var.public_subnet_id
    vpc_security_group_ids = [var.web_sg_id]
    associate_public_ip_address = true
    
    tags = {
        Name = "Web-Server"
    }
}

resource "aws_instance" "app" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = var.private_subnet_id
    vpc_security_group_ids = [var.app_sg_id]
    
    tags = {
        Name = "App-Server"
    }
}

resource "aws_instance" "database" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = var.private_subnet_id
    vpc_security_group_ids = [var.db_sg_id]
    
    tags = {
        Name = "Database-Server"
    }
}