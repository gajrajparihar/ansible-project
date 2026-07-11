locals {
  selected_azs = slice(data.aws_availability_zones.available.names, 0, 2)

  common_tags = {
    ManagedBy = "Terraform"
    Project = var.project
  }
}
