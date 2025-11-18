resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true
    
    tags = {
        Name = "${var.project_name}-${var.environment}-vpc"
        Environment = var.environment
        Project = var.project_name
    }
}

# Public Subnet 1
resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
    cidr_block = cidrsubnet(var.vpc_cidr, 8, 1)
    availability_zone = var.availability_zones[0]
    map_public_ip_on_launch = true
    
    tags = {
        Name = "${var.project_name}-${var.environment}-public-1"
        Type = "Public"
        Environment = var.environment
        Project = var.project_name
    }
}

# Public Subnet 2
resource "aws_subnet" "public2" {
    vpc_id = aws_vpc.main.id
    cidr_block = cidrsubnet(var.vpc_cidr, 8, 4)
    availability_zone = length(var.availability_zones) > 1 ? var.availability_zones[1] : var.availability_zones[0]
    map_public_ip_on_launch = true
    
    tags = {
        Name = "${var.project_name}-${var.environment}-public-2"
        Type = "Public"
        Environment = var.environment
        Project = var.project_name
    }
}

# Private Subnet 1
resource "aws_subnet" "private" {
    vpc_id = aws_vpc.main.id
    cidr_block = cidrsubnet(var.vpc_cidr, 8, 2)
    availability_zone = var.availability_zones[0]
    
    tags = {
        Name = "${var.project_name}-${var.environment}-private-1"
        Type = "Private"
        Environment = var.environment
        Project = var.project_name
    }
}

# Private Subnet 2 (for RDS)
resource "aws_subnet" "private2" {
    vpc_id = aws_vpc.main.id
    cidr_block = cidrsubnet(var.vpc_cidr, 8, 3)
    availability_zone = length(var.availability_zones) > 1 ? var.availability_zones[1] : var.availability_zones[0]
    
    tags = {
        Name = "${var.project_name}-${var.environment}-private-2"
        Type = "Private"
        Environment = var.environment
        Project = var.project_name
    }
}

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "${var.project_name}-${var.environment}-igw"
    }
}

resource "aws_eip" "nat" {
    count = var.enable_nat_gateway ? 1 : 0
    
    domain = "vpc"
    tags = {
        Name = "${var.project_name}-${var.environment}-nat-eip"
    }
}

resource "aws_nat_gateway" "main" {
    count = var.enable_nat_gateway ? 1 : 0
    
    allocation_id = aws_eip.nat[0].id
    subnet_id = aws_subnet.public.id
    tags = {
        Name = "${var.project_name}-${var.environment}-nat-gw"
    }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }
    tags = {
        Name = "${var.project_name}-${var.environment}-public-rt"
    }
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id
    
    dynamic "route" {
        for_each = var.enable_nat_gateway ? [1] : []
        content {
            cidr_block = "0.0.0.0/0"
            nat_gateway_id = aws_nat_gateway.main[0].id
        }
    }
    
    tags = {
        Name = "${var.project_name}-${var.environment}-private-rt"
    }
}

resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
    subnet_id = aws_subnet.public2.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
    subnet_id = aws_subnet.private.id
    route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private2" {
    subnet_id = aws_subnet.private2.id
    route_table_id = aws_route_table.private.id
}