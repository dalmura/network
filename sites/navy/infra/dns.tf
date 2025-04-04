module "dns" {
  source = "../../../shared/terraform_modules/site_dns"

  site_name  = local.site_name
  site_dydns = local.site_dydns

  management_devices = {}
  cloud_entries      = {}
}
