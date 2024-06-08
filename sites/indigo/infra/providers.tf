terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "dalmura-artifacts-678501865904"
    key    = "network/sites/indigo/terraform.tfstate"
    region = "ap-southeast-2"
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      domain = "dalmura"
      site   = "indigo"
    }
  }
}
