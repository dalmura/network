# Create a Route53 updater user for externaldns
resource "aws_iam_user" "k8s_dns_updater" {
  name = "dal-${var.site_name}-k8s-dns-updater"
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
      data.aws_route53_zone.global_cloud.arn,
    ]

    condition {
      test     = "ForAllValues:StringLike"
      variable = "route53:ChangeResourceRecordSetsNormalizedRecordNames"

      values = [
        "*.${local.site_domain}",
      ]
    }
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
  name = "dal-${var.site_name}-k8s-dns-permissions"
  user = aws_iam_user.k8s_dns_updater.name

  policy = data.aws_iam_policy_document.k8s_dns_permissions.json
}

resource "aws_iam_access_key" "k8s_dns_updater_key" {
  user = aws_iam_user.k8s_dns_updater.name
}
