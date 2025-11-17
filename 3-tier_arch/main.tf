provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr = "10.0.0.0/16"
  project_name = var.project_name
  environment = var.environment
  availability_zones = ["ap-south-1a"]
}

module "security" {
  source = "./modules/security"
  
  vpc_id = module.vpc.vpc_id
  vpc_cidr_block = module.vpc.vpc_cidr_block
  project_name = var.project_name
  environment = var.environment
}

module "compute" {
  source = "./modules/compute"
  
  ami_id = "ami-0912f71e06545ad88"
  instance_type = "t2.micro"
  public_subnet_id = module.vpc.public_subnet_id
  private_subnet_id = module.vpc.private_subnet_id
  web_sg_id = module.security.web_sg_id
  app_sg_id = module.security.app_sg_id
  db_sg_id = module.security.db_sg_id
}