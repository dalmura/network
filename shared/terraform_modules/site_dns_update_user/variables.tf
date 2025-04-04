variable "site_name" {
  type = string
}

locals {
  site_domain = "${var.site_name}.${data.aws_route53_zone.global_cloud.name}"
}
