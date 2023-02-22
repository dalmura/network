resource "aws_route53_zone" "global_au" {
  name    = "dalmura.au"
  comment = "Dalmura Global AU Domain"
}

resource "aws_route53_zone" "global_cloud" {
  name    = "dalmura.cloud"
  comment = "Dalmura Global Cloud Domain"
}