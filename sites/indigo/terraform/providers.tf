terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

default_tags {
  tags = {
    domain = "dalmura"
    site   = "indigo"
  }
}
