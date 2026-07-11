terraform {
backend "s3" { # Define a remote bucket (AWS S3)
    bucket = "gajraj-s3-bucket" # Set your bucket's name
    key    = "project/ansible"         # Set the bucket key
    region = "eu-central-1"    # Set the region where the bucket exists
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.0.0"
    }
    local = { 
      source = "hashicorp/local" 
      version = ">=2.5.0" }
  }
}
 
provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}
