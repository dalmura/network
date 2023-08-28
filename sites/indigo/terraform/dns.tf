locals {
  networks = yamldecode(file("${path.root}/../networks.yml"))

  # All devices including the gateway
  management_devices = local.networks["networks"]["MANAGEMENT"]["subranges"]["static"]["allocations"]

  # Filter out the gateway
  iot_internet_devices = {for k, v in local.networks["networks"]["IOT_INTERNET"]["subranges"]["static"]["allocations"]: k => v if v != "${local.site_device_prefix}-fw-0"}
}

resource "aws_route53_record" "site_au" {
  zone_id = data.aws_route53_zone.global_au.zone_id
  name    = "${local.site_name}.${data.aws_route53_zone.global_au.name}"
  type    = "CNAME"
  ttl     = "300"
  records = ["ec190e725191.sn.mynetname.net"]
}

resource "aws_route53_record" "site_cloud" {
  zone_id = data.aws_route53_zone.global_cloud.zone_id
  name    = "${local.site_name}.${data.aws_route53_zone.global_cloud.name}"
  type    = "CNAME"
  ttl     = "300"
  records = ["ec190e725191.sn.mynetname.net"]
}

resource "aws_route53_record" "site_management_devices" {
  for_each = local.management_devices

  zone_id = data.aws_route53_zone.global_cloud.zone_id
  name    = "${trimprefix(each.value, local.site_device_prefix)}.${aws_route53_record.site_cloud.fqdn}"
  type    = "A"
  ttl     = "300"
  records = [each.key]
}

resource "aws_route53_record" "site_iot_internet_devices" {
  for_each = local.iot_internet_devices

  zone_id = data.aws_route53_zone.global_cloud.zone_id
  name    = "${trimprefix(each.value, local.site_device_prefix)}.${aws_route53_record.site_cloud.fqdn}"
  type    = "A"
  ttl     = "300"
  records = [each.key]
}
