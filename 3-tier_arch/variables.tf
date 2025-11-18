variable "environment" {
  description = "Environment name"
  type = string
}

variable "project_name" {
  description = "Project name for resource naming"
  type = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type = list(string)
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type = string
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnet internet access"
  type = bool
}

variable "web_ingress_ports" {
  description = "List of ingress ports for web tier"
  type = list(number)
}

variable "app_ingress_ports" {
  description = "List of ingress ports for app tier"
  type = list(number)
}

variable "db_name" {
  description = "Database name"
  type = string
}

variable "db_username" {
  description = "Database username"
  type = string
}

variable "db_password" {
  description = "Database password"
  type = string
  sensitive = true
}