locals {
  networks = yamldecode(file("${path.root}/../networks.yaml"))
  secrets = yamldecode(file("${path.root}/../secrets.yaml"))
}

module "dns" {
  source = "../../../shared/terraform_modules/site_dns"

  site_name  = local.site_name
  site_dydns = local.site_dydns

  management_devices = local.networks["networks"]["MANAGEMENT"]["subranges"]["static"]["allocations"]
  cloud_entries      = lookup(lookup(local.secrets, "dns", {}), "cloud", {})
}
