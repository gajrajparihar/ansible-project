
##############################################################################################
###    VPC, Internet Gatway, NAT Gateway, SubNets, Route Table and Route Assosication      ###
##############################################################################################

module "vpc" {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc"

  name                = var.vpc_name
  cidr                = var.cidr
  azs                 = local.selected_azs
  public_subnets      = var.public_subnets
  public_subnet_names = var.public_subnet_names
  private_subnets     = var.private_subnets
  private_subnet_names = var.private_subnet_names

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false
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
  service_name      = "com.amazonaws.${data.aws_region.current.region}.s3"
  vpc_endpoint_type = "Gateway"
  tags = merge(local.common_tags, {
    Name = "s3-endpoint"
  })
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnets
  security_group_ids  = [aws_security_group.vpce_interface.id]
  private_dns_enabled = true

  tags = merge(local.common_tags, {
    Name = "ecr-api-endpoint"
  })
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnets
  security_group_ids  = [aws_security_group.vpce_interface.id]
  private_dns_enabled = true

  tags = merge(local.common_tags, {
    Name = "ecr-dkr-endpoint"
  })
}

resource "aws_vpc_endpoint" "logs" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.region}.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnets
  security_group_ids  = [aws_security_group.vpce_interface.id]
  private_dns_enabled = true

  tags = merge(local.common_tags, {
    Name = "logs-endpoint"
  })
}
