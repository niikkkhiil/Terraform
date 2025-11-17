provider "aws" {
  region = "ap-south-1"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

resource "aws_db_instance" "RDS" {
    allocated_storage = 10
    db_name = "terraform_rds"
    engine = "mysql"
    engine_version = "8.0"
    instance_class = "db.t2.micro"
    username = "foo"
    password = var.db_password
    parameter_group_name = "default.mysql8.0"
    skip_final_snapshot = true
}