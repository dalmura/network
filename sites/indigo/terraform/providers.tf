terraform {
  required_providers {
    routeros = {
      source  = "GNewbury1/routeros"
      version = "0.3.2"
    }
  }
}

provider "routeros" {
  hosturl = var.hosturl
}
