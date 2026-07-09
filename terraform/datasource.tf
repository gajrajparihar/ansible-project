
data "aws_vpc" "prod-vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name}"]
  }
  depends_on = [module.vpc]
}

data "aws_nat_gateway" "prod-ng" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.prod-vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name}-eu-central-1a"]
  }
  
}

# Output the values
output "vpc_id" {
  value = data.aws_vpc.prod-vpc.id
}

output "nat_gateway_id" {
  value = data.aws_nat_gateway.prod-ng.id
}

data "aws_subnets" "public-subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.prod-vpc.id]
  }
  tags = {
    "Tier" = "Public"
  }
}

data "aws_subnet" "public-subnet1" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.prod-vpc.id]
  }
  filter {
    name   =  "tag:Name"
    values = ["sw-public-1"]
  }  
}
output "public-subnet-id" {
  value = data.aws_subnet.public-subnet1.id  
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-arm64"]
  }
}
