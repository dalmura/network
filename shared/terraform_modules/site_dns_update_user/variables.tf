variable "site_name" {
  type = string
}

locals {
  site_global_domain = "${var.site_name}.${data.aws_route53_zone.global_cloud.name}"
  site_au_domain     = "${var.site_name}.${data.aws_route53_zone.global_au.name}"
}
