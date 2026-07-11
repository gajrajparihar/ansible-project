variable "project" {
  default     = "terraform-ansible"
}


#######################################################################################
###############    These variables  will be used for network definition   #############
#######################################################################################

variable "vpc_name" {
  default     = "terraform-ansible-vpc"
}

variable "cidr" {
  default     = "10.1.0.0/16"
}


variable "public_subnets" {
  default = ["10.1.255.0/24", "10.1.254.0/24"]
}

variable "public_subnet_names" {
  default = ["sw-public-1", "sw-public-2"]
}

variable "private_subnets" {
  default =["10.1.252.0/24", "10.1.253.0/24"]
}

variable "private_subnet_names" {
  default = ["sw-private-1", "sw-private-2"]
}

variable "ssl_policy" { default = "ELBSecurityPolicy-TLS13-1-2-2021-06" }

variable "ec2_key_name" {
  default     = "terraform-ansible"
}

variable "ami_id" {
  default     = "ami-0f92e2dae65c68e2f"
}
