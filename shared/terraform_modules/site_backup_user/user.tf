# Backup user
resource "aws_iam_user" "k8s_backups" {
  name = "dal-${var.site_name}-k8s-backups"
}

data "aws_iam_policy_document" "k8s_backups_permissions" {
  statement {
    sid = "GrantBackupAccess"
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:PutObjectTagging",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:DeleteObject",
    ]

    resources = [
      "arn:aws:s3:::${data.aws_s3_bucket.global_backups.id}",
      "arn:aws:s3:::${data.aws_s3_bucket.global_backups.id}/${var.site_name}/*",
    ]
  }
}

resource "aws_iam_user_policy" "k8s_backups_permissions" {
  name = "dal-${var.site_name}-k8s-backups-permissions"
  user = aws_iam_user.k8s_backups.name

  policy = data.aws_iam_policy_document.k8s_backups_permissions.json
}

resource "aws_iam_access_key" "k8s_backups_key" {
  user = aws_iam_user.k8s_backups.name
}
