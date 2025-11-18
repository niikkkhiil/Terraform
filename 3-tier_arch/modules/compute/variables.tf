variable "ami_id" {
    description = "AMI ID for instances"
    type = string
}

variable "instance_type" {
    description = "Instance type"
    type = string
}

variable "project_name" {
    description = "Project name for resource naming"
    type = string
}

variable "environment" {
    description = "Environment name"
    type = string
}

variable "vpc_id" {
    description = "VPC ID"
    type = string
}

variable "public_subnet_id" {
    description = "Public subnet ID"
    type = string
}

variable "private_subnet_id" {
    description = "Private subnet ID"
    type = string
}

variable "web_ingress_ports" {
    description = "List of ingress ports for web tier"
    type = list(number)
}

variable "app_ingress_ports" {
    description = "List of ingress ports for app tier"
    type = list(number)
}

variable "public_subnet_cidrs" {
    description = "List of public subnet CIDRs for ALB access"
    type = list(string)
}