#Create a VPC
resource "aws_vpc" "sample_vpc" {
	cidr_block = var.vpc_cidr_block
	tags       = {
		Name   = "My Sample VPC"
	}
}

#Create a IGW and attach it to VPC
resource "aws_internet_gateway" "igw_1" {
	vpc_id     = aws_vpc.sample_vpc.id
	tags       = {
		Name   = "My Sample Internet Gateway"
	}
}

# Creating the public subnets in two different AZ's
resource "aws_subnet" "public_subnet_1" {
	vpc_id 		            = aws_vpc.sample_vpc.id
	cidr_block              = var.public_subnet_1a
	availability_zone       = var.az1
	map_public_ip_on_launch = true
	tags 					= {
		Name 				= "Public subnet 1"
	}
}

resource "aws_subnet" "public_subnet_2" {
	vpc_id 					= aws_vpc.sample_vpc.id
	cidr_block  			= var.public_subnet_1b
	availability_zone  		= var.az2
	map_public_ip_on_launch = true
	tags 					= {
		Name 				= "Public subnet 2"
	}
}

# Creating a security group for the application
resource "aws_security_group" "sample_sg" {
	name_prefix 		= "application"
	vpc_id 				= aws_vpc.sample_vpc.id
	
	ingress {
		from_port	    = 80
		to_port         = 80
		protocol        = "TCP"
		cidr_blocks     = ["0.0.0.0/0"]
	}
	
	egress {
		from_port       = 0
		to_port         = 0
		protocol        = "-1"
		cidr_blocks     = ["0.0.0.0/0"]
	}
	
	tags                = {
		Name            = "Application Security Group"
	}
}

	