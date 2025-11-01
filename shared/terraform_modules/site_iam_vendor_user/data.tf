data "aws_caller_identity" "current" {}

data "aws_s3_bucket" "global_backups" {
  bucket = "dal-site-backups"
}

locals {
  account_id = data.aws_caller_identity.current.account_id
}
