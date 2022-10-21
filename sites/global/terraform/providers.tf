terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket = "dalmura-artifacts-678501865904"
    key    = "network/sites/global/terraform.tfstate"
    region = "ap-southeast-2"
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      domain = "dalmura"
      site   = "global"
    }
  }
}