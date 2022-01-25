#kms key for application cluster and blockchain cluster encryption
resource "aws_kms_key" "cw_logs_ct_kms_key" {
  description             = "The KMS key for cloudwatch log group receives events from cloudtrial"
  deletion_window_in_days = 30
  key_usage               = "ENCRYPT_DECRYPT"
  enable_key_rotation     = true
  policy = data.aws_iam_policy_document.cloudtrail_kms_policy_doc.json
  tags = merge(
    local.tags,
    {
      "Name" = "${local.std_name}-cw-logs-cloudtrail"
      "Cluster_type" = "both"
    },)
}
#kms key alias for cloudwatch logs related to cloudtrail
resource "aws_kms_alias" "cw_logs_ct_kms_key_alias" {
  name          = "alias/${local.std_name}-cloudwatch-logs"
  target_key_id = aws_kms_key.cw_logs_ct_kms_key.id
}
#setting up cloudwatch logs
resource "aws_cloudwatch_log_group" "cloudtrail_cw_logs" {
  name = "${local.std_name}-cloudtrail-logs"
  retention_in_days = var.cw_logs_retention_period
  kms_key_id = aws_kms_key.cw_logs_ct_kms_key.arn
  tags = merge(local.tags, { Name = "${local.std_name}-cloudtrail-logs-group", Cluster_type = "both"})
  depends_on = [aws_kms_key.cw_logs_ct_kms_key]
}
#setting up iam role for cloudwatch related to cloudtrail
resource "aws_iam_role" "cloudtrail_cloudwatch_role" {
  name = "${local.std_name}-cloudtrail"
  assume_role_policy = data.aws_iam_policy_document.cloudtrail_assume_role.json
}
#enabling cloudtrail
resource "aws_cloudtrail" "cloudtrail_events" {
    name = "${local.std_name}-cloudtrail"
    s3_bucket_name = aws_s3_bucket.s3_bucket.bucket
    cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail_cw_logs.arn}:*"
    cloud_watch_logs_role_arn = aws_iam_role.cloudtrail_cloudwatch_role.arn
    enable_log_file_validation = true
    enable_logging = true
    include_global_service_events = true
    is_multi_region_trail = false
    is_organization_trail = false
    kms_key_id = aws_kms_key.cw_logs_ct_kms_key.arn
     event_selector {
            include_management_events = true
            read_write_type = "WriteOnly"

    }
    tags = merge(local.tags, {Name = "${local.std_name}-cloudtrail-logs", Cluster_type = "both"})
    depends_on = [aws_cloudwatch_log_group.cloudtrail_cw_logs, aws_s3_bucket_policy.bucket_policy]
}
#iam policy for cloudwatch logs related to cloudtrail
resource "aws_iam_policy" "cloudtrail_cloudwatch_logs" {
  name   = "${local.std_name}-ct-cloudwatch-logs"
  policy = data.aws_iam_policy_document.cloudtrail_cloudwatch_logs.json
}
#iam policy attachment for cloudwatch logs related to cloudtrail
resource "aws_iam_policy_attachment" "main" {
  name       = "${local.std_name}-ct-cloudwatch-logs"
  policy_arn = aws_iam_policy.cloudtrail_cloudwatch_logs.arn
  roles      = [aws_iam_role.cloudtrail_cloudwatch_role.name]
}
#creating an s3 bucket
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${local.std_name}-${var.s3_bucket_name_cloudtrail}"
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
      "Name" = "${local.std_name}-${var.s3_bucket_name_cloudtrail}"
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
  bucket     = "${local.std_name}-${var.s3_bucket_name_cloudtrail}"
  depends_on = [aws_s3_bucket.s3_bucket]
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck20150319",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${local.std_name}-${var.s3_bucket_name_cloudtrail}"
        },
        {
            "Sid": "AWSCloudTrailWrite20150319",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${local.std_name}-${var.s3_bucket_name_cloudtrail}/AWSLogs/${var.aws_account_number}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        },
      {
        Sid       = "HTTPRestrict"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = "arn:aws:s3:::${local.std_name}-${var.s3_bucket_name_cloudtrail}/*",
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
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
    "Id" : "${local.std_name}-${var.s3_bucket_name_cloudtrail}",
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "EnableIAMUserPermissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${var.aws_account_number}:root"
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
      {
        "Sid" : "AllowaccessforKeyAdministrators",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "${var.aws_role_arn}"
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
          "kms:CancelKeyDeletion",
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
  name          = "alias/${local.std_name}-${var.s3_bucket_name_cloudtrail}"
  target_key_id = aws_kms_key.s3_kms_key.id
}