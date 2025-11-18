# Project Configuration
project_name = "my-3tier-app"
environment = "production"

# Network Configuration
vpc_cidr = "10.0.0.0/16"
availability_zones = ["ap-south-1a", "ap-south-1b"]
enable_nat_gateway = true

# Compute Configuration
ami_id = "ami-0912f71e06545ad88"
instance_type = "t3.micro"

# Security Configuration
web_ingress_ports = [80, 443, 22]
app_ingress_ports = [8080, 22]

# Database Configuration
db_name = "myapp"
db_username = "admin"
db_password = "AmbujaCementssebanahuaPassword$123"