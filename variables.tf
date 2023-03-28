variable "aws_region" {}

variable "vpc_cidr_block" {
    default    = "10.0.0.0/16"
}

variable "public_subnet_1a" {
#    description = "public subnet for AZ-1a"
 }
variable "public_subnet_1b" { 
#    description = "public subnet for AZ-1b"
}

variable "az1" {
#    description = "Availability Zone for Region-1a"
}
variable "az2" {
#    description = "Availability Zone for Region-1b"
}

variable docker_image { }
