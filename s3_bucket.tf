#creating an s3 bucket
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.s3_bucket_name}"
  #bucket = local.bucket_name #can be variable
  acl    = "private"
  #policy = aws_s3_bucket_policy.bucket_policy.id
  force_destroy = true
  versioning {
    enabled = true
  }
  tags = merge(
    local.tags,
    {
      "Name" = "${var.s3_bucket_name}"
    },)
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.s3_kms_key.id
      }
    }
  }
}
#blocking public access to s3 bucket
resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  bucket                  = aws_s3_bucket.s3_bucket.id
  depends_on              = [aws_s3_bucket.s3_bucket, aws_s3_bucket_policy.bucket_policy]
}
#setting up a bucket policy to restrict access
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket     = "${var.s3_bucket_name}"
  depends_on = [aws_s3_bucket.s3_bucket]
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "tf_bucketpolicy",
    "Statement" : [
      {
        "Sid" : "allowiamrole",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "${var.aws_role_arn}"
        },
        "Action" : [
          "s3:GetObject",
          "s3:PutObject"
        ],
        "Resource" : "arn:aws:s3:::${var.s3_bucket_name}/*"
      },
      {
        "Sid" : "Stmt1625783799751",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "${var.aws_role_arn}"
        },
        "Action" : "s3:ListBucket",
        "Resource" : "arn:aws:s3:::${var.s3_bucket_name}"
      }
    ]
  })
}
#creating kms key that is used to encrypt data at rest in S3 bucket
resource "aws_kms_key" "s3_kms_key" {
  description             = "The kms key for app eks"
  deletion_window_in_days = 30
  key_usage               = "ENCRYPT_DECRYPT"
  enable_key_rotation     = true
  tags = merge(
    local.tags,
    {
      "Name" = "s3-bucket-kms-key"
    },)
  policy = jsonencode({
    "Id" : "${local.std_name}-${var.s3_bucket_name}",
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "EnableIAMUserPermissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${var.aws_core_account_number}:root"
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
      {
        "Sid" : "AllowaccessforKeyAdministrators",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "${var.aws_user_arn}"
        },
        "Action" : [
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:TagResource",
          "kms:UntagResource",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "Allowuseofthekey",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "${var.aws_user_arn}"
        },
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "Allowattachmentofpersistentresources",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "${var.aws_role_arn}"
        },
        "Action" : [
          "kms:CreateGrant",
          "kms:ListGrants",
          "kms:RevokeGrant"
        ],
        "Resource" : "*",
        "Condition" : {
          "Bool" : {
            "kms:GrantIsForAWSResource" : "true"
          }
        }
      }
    ]
  })
}
#setting up an alias for the kms key used with s3 bucket data encryption
resource "aws_kms_alias" "s3_kms_key" {
  name          = "alias/s3_key_${var.s3_bucket_name}"
  target_key_id = aws_kms_key.s3_kms_key.id
}
