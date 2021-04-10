

variable "region" {
  default     = "us-east-2"
  type        = string
  description = "Region of the VPC"
}

variable "ami_id" {
  default     = "ami-01e7ca2ef94a0ae86"
  type        = string
  description = "Region of the VPC"
}


variable "aws_key_name" {
  default     = "gaurav"
  description = "aws_key_name"
}


variable "cidr_block" {
  default     = "10.0.0.0/16"
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidr_blocks" {
  default     = ["10.0.0.0/24"]
  type        = list
  description = "List of public subnet CIDR blocks"
}

variable "private_subnet_cidr_blocks" {
  default     = ["10.0.1.0/24"]
  type        = list
  description = "List of private subnet CIDR blocks"
}

variable "availability_zones" {
  default     = ["us-east-2a", "us-east-2b","us-east-2c"]
  type        = list
  description = "List of availability zones"
}
 