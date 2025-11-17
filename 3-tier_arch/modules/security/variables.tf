variable "vpc_id" {
    description = "VPC ID for security groups"
    type        = string
}

variable "vpc_cidr_block" {
    description = "CIDR block of the VPC"
    type        = string
}

variable "project_name" {
    description = "Project name for resource naming"
    type        = string
}

variable "environment" {
    description = "Environment name"
    type        = string
}