# Application Load Balancer Security Group
resource "aws_security_group" "alb" {
    name_prefix = "${var.project_name}-${var.environment}-alb-"
    vpc_id = var.vpc_id
    
    ingress {
        from_port = 80
        to_port   = 80
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        from_port = 443
        to_port   = 443
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress {
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    tags = {
        Name = "${var.project_name}-${var.environment}-alb-sg"
        Environment = var.environment
        Project = var.project_name
    }
}

# Web Tier Security Group
resource "aws_security_group" "web" {
    name_prefix = "${var.project_name}-${var.environment}-web-"
    vpc_id = var.vpc_id
    
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.alb.id]
    }
    
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.vpc_cidr_block]
    }
    
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    tags = {
        Name = "${var.project_name}-${var.environment}-web-sg"
        Environment = var.environment
        Project = var.project_name
    }
}

# App Tier Security Group
resource "aws_security_group" "app" {
    name_prefix = "${var.project_name}-${var.environment}-app-"
    vpc_id = var.vpc_id
    
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        security_groups = [aws_security_group.web.id]
    }
    
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.vpc_cidr_block]
    }
    
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    tags = {
        Name = "${var.project_name}-${var.environment}-app-sg"
        Environment = var.environment
        Project = var.project_name
    }
}

# Database Security Group
resource "aws_security_group" "db" {
    name_prefix = "${var.project_name}-${var.environment}-db-"
    vpc_id = var.vpc_id
    
    ingress {
        from_port = 3306
        to_port   = 3306
        protocol  = "tcp"
        security_groups = [aws_security_group.app.id]
    }
    
    tags = {
        Name = "${var.project_name}-${var.environment}-db-sg"
        Environment = var.environment
        Project = var.project_name
    }
}