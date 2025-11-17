variable "ami_id" {
    description = "AMI ID for instances"
    type = string
    default = "ami-0912f71e06545ad88"
}

variable "instance_type" {
    description = "Instance type"
    type = string
    default = "t2.micro"
}

variable "public_subnet_id" {
    description = "Public subnet ID"
    type = string
}

variable "private_subnet_id" {
    description = "Private subnet ID"
    type = string
}

variable "web_sg_id" {
    description = "Web security group ID"
    type = string
}

variable "app_sg_id" {
    description = "App security group ID"
    type = string
}

variable "db_sg_id" {
    description = "Database security group ID"
    type = string
}