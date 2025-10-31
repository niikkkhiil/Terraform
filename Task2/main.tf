provider "aws" {
  region = "ap-south-1"
}

module "module_output" {
    source = "D:\\Project\\Terraform\\Task2\\ec2\\module_ec2.tf"
    Name = "Terraform EC2 Instance from Module"
  
}

output "module_output_ipweb" {
    value = module.module_output.module_web
}

output "module_output_db" {
    value = module.module_output.module_db
}