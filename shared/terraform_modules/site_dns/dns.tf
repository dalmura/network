resource "aws_route53_record" "site_au" {
  zone_id = data.aws_route53_zone.global_au.zone_id
  name    = "${var.site_name}.${data.aws_route53_zone.global_au.name}"
  type    = "CNAME"
  ttl     = "300"
  records = [var.site_dydns]
}

resource "aws_route53_record" "site_cloud" {
  zone_id = data.aws_route53_zone.global_cloud.zone_id
  name    = "${var.site_name}.${data.aws_route53_zone.global_cloud.name}"
  type    = "CNAME"
  ttl     = "300"
  records = [var.site_dydns]
}

resource "aws_route53_record" "site_management_devices" {
  for_each = var.management_devices

  zone_id = data.aws_route53_zone.global_cloud.zone_id
  name    = "${trimprefix(each.value, local.site_device_prefix)}.${aws_route53_record.site_cloud.fqdn}"
  type    = "A"
  ttl     = "300"
  records = [each.key]
}

resource "aws_route53_record" "site_cloud_entries" {
  for_each = var.cloud_entries

  zone_id = data.aws_route53_zone.global_cloud.zone_id
  name    = "${each.key}.${aws_route53_record.site_cloud.fqdn}"
  type    = "A"
  ttl     = "300"
  records = [each.value]
}
