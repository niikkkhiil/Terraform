variable "ec2_db" {
  type = string
}

variable "ec2_web" {
  type = string
}

variable "ingressrules" {
    type = list(number)
    default = [ 80, 443 ] 
}

variable "egressrules" {
    type = list(number)
    default = [ 80,443 ]
}

resource "aws_instance" "DB" {
    ami = "ami-0912f71e06545ad88"
    instance_type = "t2.micro"
    tags = {
        Name = var.ec2_db
    }
}

resource "aws_instance" "web_server" {
    ami = "ami-0912f71e06545ad88"
    instance_type = "t2.micro"
    security_groups = [security_groups.module_sg.name]
    tags = {
        Name = var.ec2_web
    }
}

resource "aws_eip" "eip_web" {
    instance = aws_instance.web_server.id
    tags = {
        Name = "EIP for Web Server"
    }
  
}

output "module_db" {
    value = aws_instance.DB.id
}

output "module_web" {
    value = aws_instance.web_server.id
}

resource "security_groups" "module_sg" {
    Name = "Terraform_module_sg"
    description = "Security Group for module EC2 instances"

   dynamic "ingress" {
        iterator = port
        for_each = var.ingressrules
        content{
            from_port = port.value
            to_port = port.value
            protocol = "tcp"
            cidr_blocks = ["192.168.0.0/24"]
        }
     
   }

   dynamic "egress" {
        iterator = port
        for_each = var.egressrules
        content{
            from_port = port.value
            to_port = port.value
            protocol = "tcp"
            cidr_blocks = ["192.168.0.0/24"]
        }
     
   }
  
}