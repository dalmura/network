# Backup IAM User
module "backup_user" {
  source = "../../../shared/terraform_modules/site_backup_user"

  site_name = local.site_name
}

# DNS Management IAM User
module "dns_update_user" {
  source = "../../../shared/terraform_modules/site_dns_update_user"

  site_name = local.site_name
}
