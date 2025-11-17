# RDS Subnet Group
resource "aws_db_subnet_group" "main" {
  name = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = var.private_subnet_ids
  
  tags = {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
    Environment = var.environment
    Project = var.project_name
  }
}

# RDS Security Group
resource "aws_security_group" "rds" {
  name_prefix = "${var.project_name}-${var.environment}-rds-"
  vpc_id = var.vpc_id
  
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [var.app_security_group_id]
  }
  
  tags = {
    Name = "${var.project_name}-${var.environment}-rds-sg"
    Environment = var.environment
    Project = var.project_name
  }
}

# RDS Instance
resource "aws_db_instance" "main" {
  identifier = "${var.project_name}-${var.environment}-db"

  allocated_storage = var.allocated_storage
  storage_type = "gp2"
  engine = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  
  skip_final_snapshot = true
  
  tags = {
    Name = "${var.project_name}-${var.environment}-rds"
    Environment = var.environment
    Project = var.project_name
  }
}