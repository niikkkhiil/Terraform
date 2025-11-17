provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr = var.vpc_cidr
  project_name = var.project_name
  environment = var.environment
  availability_zones = var.availability_zones
  enable_nat_gateway = var.enable_nat_gateway
}

module "compute" {
  source = "./modules/compute"
  
  ami_id = var.ami_id
  instance_type = var.instance_type
  project_name = var.project_name
  environment = var.environment
  vpc_id = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_id
  private_subnet_id = module.vpc.private_subnet_id
  web_ingress_ports = var.web_ingress_ports
  app_ingress_ports = var.app_ingress_ports
}

module "alb" {
  source = "./modules/alb"
  
  project_name = var.project_name
  environment = var.environment
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  web_instance_id = module.compute.web_instance_id
}

module "rds" {
  source = "./modules/rds"
  
  project_name = var.project_name
  environment = var.environment
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  app_security_group_id = module.compute.app_security_group_id
  db_name = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}