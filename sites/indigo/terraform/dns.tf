locals {
  networks = yamldecode(file("${path.root}/../networks.yaml"))
  secrets = yamldecode(file("${path.root}/../secrets.yaml"))

  # All devices including the gateway
  management_devices = local.networks["networks"]["MANAGEMENT"]["subranges"]["static"]["allocations"]

  # Optional cloud entries
  cloud_entries = lookup(lookup(local.secrets, "dns", {}), "cloud", {})
}

resource "aws_route53_record" "site_au" {
  zone_id = data.aws_route53_zone.global_au.zone_id
  name    = "${local.site_name}.${data.aws_route53_zone.global_au.name}"
  type    = "CNAME"
  ttl     = "300"
  records = [local.site_dydns]
}

resource "aws_route53_record" "site_cloud" {
  zone_id = data.aws_route53_zone.global_cloud.zone_id
  name    = "${local.site_name}.${data.aws_route53_zone.global_cloud.name}"
  type    = "CNAME"
  ttl     = "300"
  records = [local.site_dydns]
}

resource "aws_route53_record" "site_management_devices" {
  for_each = local.management_devices

  zone_id = data.aws_route53_zone.global_cloud.zone_id
  name    = "${trimprefix(each.value, local.site_device_prefix)}.${aws_route53_record.site_cloud.fqdn}"
  type    = "A"
  ttl     = "300"
  records = [each.key]
}

resource "aws_route53_record" "site_cloud_entries" {
  for_each = local.cloud_entries

  zone_id = data.aws_route53_zone.global_cloud.zone_id
  name    = "${each.key}.${aws_route53_record.site_cloud.fqdn}"
  type    = "A"
  ttl     = "300"
  records = [each.value]
}
