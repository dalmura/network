# Storage bucket for site backups
resource "aws_s3_bucket" "global_backups" {
  bucket = "dal-site-backups"
}

resource "aws_s3_bucket_public_access_block" "global_backups" {
  bucket = aws_s3_bucket.global_backups.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "global_backups" {
  bucket = aws_s3_bucket.global_backups.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "global_backups" {
  bucket = aws_s3_bucket.global_backups.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Backup user
resource "aws_iam_user" "k8s_backups" {
  name = "dalmura-k8s-backups"
}

data "aws_iam_policy_document" "k8s_backups_permissions" {
  statement {
    sid = "GrantBackupAccess"
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:DeleteObject"
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.global_backups.id}",
      "arn:aws:s3:::${aws_s3_bucket.global_backups.id}/*"
    ]
  }
}

resource "aws_iam_user_policy" "k8s_backups_permissions" {
  name = "k8s-backups-permissions"
  user = aws_iam_user.k8s_backups.name

  policy = data.aws_iam_policy_document.k8s_backups_permissions.json
}
