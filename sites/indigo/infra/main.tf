terraform {
  required_providers {
    routeros = {
      # https://registry.terraform.io/providers/GNewbury1/routeros/latest
      source = "GNewbury1/routeros"
    }
  }
}

provider "routeros" {
  hosturl  = "https://gateway.indigo.dalmura.au"
}
