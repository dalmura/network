data "aws_route53_zone" "global_cloud" {
  name = "dalmura.cloud."
}

data "aws_route53_zone" "global_au" {
  name = "dalmura.au."
}
