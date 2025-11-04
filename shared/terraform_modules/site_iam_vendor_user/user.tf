# IAM Vendor User
resource "aws_iam_user" "iam_vendor" {
  name = "dal-${var.site_name}-iam-vendor"
}

resource "aws_iam_access_key" "iam_vendor_key" {
  user = aws_iam_user.iam_vendor.name
}

data "aws_iam_policy_document" "iam_vendor_permissions" {
  statement {
    sid = "GrantVendorAccess"
    effect = "Allow"

    actions = [
      "iam:AttachUserPolicy",
      "iam:CreateAccessKey",
      "iam:CreateUser",
      "iam:DeleteAccessKey",
      "iam:DeleteUser",
      "iam:DeleteUserPolicy",
      "iam:DetachUserPolicy",
      "iam:GetUser",
      "iam:ListAccessKeys",
      "iam:ListAttachedUserPolicies",
      "iam:ListGroupsForUser",
      "iam:ListUserPolicies",
      "iam:PutUserPolicy",
      "iam:AddUserToGroup",
      "iam:RemoveUserFromGroup",
      "iam:TagUser",
    ]

    resources = [
      "arn:aws:iam::${local.account_id}:user/dal-${var.site_name}-vault-*",
    ]
  }
}

resource "aws_iam_user_policy" "iam_vendor_permissions" {
  name = "dal-${var.site_name}-iam-vendor-permissions"
  user = aws_iam_user.iam_vendor.name

  policy = data.aws_iam_policy_document.iam_vendor_permissions.json
}

# This is the policy that will be attached to all new users
data "aws_iam_policy_document" "iam_vended_permissions" {
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
      "arn:aws:s3:::${data.aws_s3_bucket.global_backups.id}/${var.site_name}/$${aws:PrincipalTag/app}/$${aws:PrincipalTag/role}/*",
    ]

    # Barman (CNPG backup) requires ListBucket at the root for some reason?
    #condition {
    #  test     = "StringLike"
    #  variable = "s3:prefix"
    #
    #  values = [
    #    "${var.site_name}/$${aws:PrincipalTag/app}/$${aws:PrincipalTag/role}/"
    #  ]
    #}
  }
}

resource "aws_iam_policy" "iam_vended_permissions" {
  name        = "dal-${var.site_name}-iam-vended-permissions"
  description = "Permissions for all ${var.site_name} vended users"

  policy = data.aws_iam_policy_document.iam_vended_permissions.json
}
