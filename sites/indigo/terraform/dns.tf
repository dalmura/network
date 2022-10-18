resource "aws_route53_record" "site" {
  zone_id = data.aws_route53_zone.global.zone_id
  name    = "indigo.${data.aws_route53_zone.global.name}"
  type    = "CNAME"
  ttl     = "300"
  records = ["ec190e725191.sn.mynetname.net"]
}
