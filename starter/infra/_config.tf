terraform {
  backend "s3" {
    bucket = "udacity-tf-bawi-east-2" # Update here with your S3 bucket
    key    = "terraform/terraform.tfstate"
    region = "us-east-2"
    profile = "udacity"
  }
}

provider "aws" {
  region = "us-east-2"
  profile = "udacity"

  default_tags {
    tags = local.tags
  }
}