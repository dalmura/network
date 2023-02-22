resource "aws_route53_record" "site_au" {
  zone_id = data.aws_route53_zone.global_au.zone_id
  name    = "indigo.${data.aws_route53_zone.global_au.name}"
  type    = "CNAME"
  ttl     = "300"
  records = ["ec190e725191.sn.mynetname.net"]
}

resource "aws_route53_record" "site_cloud" {
  zone_id = data.aws_route53_zone.global_cloud.zone_id
  name    = "indigo.${data.aws_route53_zone.global_cloud.name}"
  type    = "CNAME"
  ttl     = "300"
  records = ["ec190e725191.sn.mynetname.net"]
}