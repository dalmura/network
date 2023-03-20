resource "aws_route53_zone" "global_au" {
  name    = "dalmura.au"
  comment = "Dalmura Global AU Domain"
}

resource "aws_route53_zone" "global_cloud" {
  name    = "dalmura.cloud"
  comment = "Dalmura Global Cloud Domain"
}

# Create a Route53 updater user for externaldns
resource "aws_iam_user" "k8s_dns_updater" {
  name = "dalmura-k8s-dns-updater"
}

data "aws_iam_policy_document" "k8s_dns_permissions" {
  statement {
    actions = [
      "route53:GetChange",
    ]

    resources = [
      "arn:aws:route53:::change/*",
    ]
  }

  statement {
    actions = [
      "route53:ChangeResourceRecordSets",
    ]

    resources = [
      aws_route53_zone.global_au.arn,
      aws_route53_zone.global_cloud.arn,
    ]
  }

  statement {
    actions = [
      "route53:ListHostedZones",
      "route53:ListHostedZonesByName",
      "route53:ListResourceRecordSets",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_user_policy" "k8s_dns_permissions" {
  name = "k8s-dns-permissions"
  user = aws_iam_user.k8s_dns_updater.name

  policy = data.aws_iam_policy_document.k8s_dns_permissions.json
}
