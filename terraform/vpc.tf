
##############################################################################################
###    VPC, Internet Gatway, NAT Gateway, SubNets, Route Table and Route Assosication      ###
##############################################################################################

module "vpc" {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc"

  name                = var.vpc_name
  cidr                = var.cidr
  azs                 = var.availability_zones
  public_subnets      = var.public_subnets
  public_subnet_names = var.public_subnet_names
  private_subnets     = var.private_subnets
  private_subnet_names = var.private_subnet_names

  enable_nat_gateway = true
  single_nat_gateway = false
  one_nat_gateway_per_az = true
  enable_dns_hostnames = true
  map_public_ip_on_launch = true
  public_subnet_tags = {
    Tier = "Public"
    Project = var.project
  }
  private_subnet_tags = {
    Tier = "Private"
    Project = var.project
  }
  tags = local.common_tags
}

resource "aws_vpc_endpoint" "s3-endpoint" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.eu-central-1.s3"
  vpc_endpoint_type = "Gateway"
  tags = merge(local.common_tags, {
    Name = "s3-endpoint"
  })
}
