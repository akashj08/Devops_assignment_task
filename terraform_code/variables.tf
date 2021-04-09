variable "region" {
  description = "AWS Deployment region.."
  default = "us-east-1"
}




variable "environment" {
  description = "Environment"
  default = "Dev"
}


variable "vpc_cidr" {
  description = "vpc_cidr"
  default = "10.1.0.0/16"
}

variable "public_subnets_cidr" {
  description = "public_subnets_cidr"
  default = "10.1.0.0/24"
}

variable "private_subnets_cidr" {
  description = "private_subnets_cidr"
  default = "10.2.0.0/24"
}


variable "dev_availability_zones" {
  description = "dev_availability_zones"
  default = "us-east-1"
}

