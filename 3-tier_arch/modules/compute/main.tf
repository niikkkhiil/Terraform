# Web Server
resource "aws_instance" "web" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = var.public_subnet_id
    vpc_security_group_ids = [aws_security_group.web.id]
    associate_public_ip_address = true
    
    tags = {
        Name = "Web-Server"
    }
}

# Web Tier Security Group
resource "aws_security_group" "web" {
    name_prefix = "${var.project_name}-${var.environment}-web-"
    vpc_id = var.vpc_id
    
    dynamic "ingress" {
        for_each = var.web_ingress_ports
        content {
            from_port = ingress.value
            to_port = ingress.value
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }
    
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    tags = {
        Name = "${var.project_name}-${var.environment}-web-sg"
    }
}
# App Server
resource "aws_instance" "app" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = var.private_subnet_id
    vpc_security_group_ids = [aws_security_group.app.id]
    
    tags = {
        Name = "App-Server"
    }
}

# App Tier Security Group
resource "aws_security_group" "app" {
    name_prefix = "${var.project_name}-${var.environment}-app-"
    vpc_id      = var.vpc_id
    
    dynamic "ingress" {
        for_each = var.app_ingress_ports
        content {
            from_port = ingress.value
            to_port = ingress.value
            protocol = "tcp"
            security_groups = [aws_security_group.web.id]
        }
    }
    
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    tags = {
        Name = "${var.project_name}-${var.environment}-app-sg"
    }
}


