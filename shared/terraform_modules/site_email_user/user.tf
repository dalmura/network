# Create a Amazon SES Email user
resource "aws_iam_user" "k8s_email_sender" {
  name = "dal-${var.site_name}-k8s-email-sender"
}

data "aws_iam_policy_document" "k8s_email_permissions" {
  statement {
    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail",
    ]

    resources = [
      data.aws_sesv2_email_identity.dalmura_cloud.arn,
    ]

    condition {
      test     = "StringLike"
      variable = "ses:FromAddress"

      values = [
        "${var.site_name}+*@${data.aws_sesv2_email_identity.dalmura_cloud.email_identity}",
      ]
    }
  }
}

resource "aws_iam_user_policy" "k8s_email_permissions" {
  name = "dal-${var.site_name}-k8s-email-permissions"
  user = aws_iam_user.k8s_email_sender.name

  policy = data.aws_iam_policy_document.k8s_email_permissions.json
}

resource "aws_iam_access_key" "k8s_email_sender_key" {
  user = aws_iam_user.k8s_email_sender.name
}
