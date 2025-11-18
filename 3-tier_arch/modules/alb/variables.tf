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

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type = list(string)
}

variable "web_instance_id" {
  description = "Web server instance ID for target group attachment"
  type = string
}
variable "alb_ingress_ports" {
  description = "List of ingress ports for ALB"
  type = list(number)
}