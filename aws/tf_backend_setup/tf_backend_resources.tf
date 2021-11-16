resource "aws_kms_key" "tf_backend_s3_bucket_kms_key" {
  description = "The KMS key used to encrypt S3 bucket managed to handle terraform.state files"
  deletion_window_in_days = 30
  key_usage = "ENCRYPT_DECRYPT"
  enable_key_rotation = true
  tags = local.tags
  policy = jsonencode({
    "Id": "key-consolepolicy-3",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "EnableIAMUserPermissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.aws_account_id}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "AllowaccessforKeyAdministrators",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${var.aws_role_arn}"
            },
            "Action": [
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
            "Resource": "*"
        },
        {
            "Sid": "Allowattachmentofpersistentresources",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${var.aws_role_arn}"
            },
            "Action": [
                "kms:CreateGrant",
                "kms:ListGrants",
                "kms:RevokeGrant"
            ],
            "Resource": "*",
            "Condition": {
                "Bool": {
                    "kms:GrantIsForAWSResource": "true"
                }
            }
        }
    ]
  })
}
resource "aws_s3_bucket" "tf_backend_s3_bucket" {
  bucket = var.tf_backend_s3_bucket
  acl    = "private"
  force_destroy = true
  versioning {
    enabled = true
  }
  tags = local.tags
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
        kms_master_key_id = aws_kms_key.tf_backend_s3_bucket_kms_key.id
      }
    }
  }
}
resource "aws_s3_bucket_public_access_block" "tf_backend_s3_bucket_public_access_block" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  bucket = aws_s3_bucket.tf_backend_s3_bucket.id
  depends_on = [aws_s3_bucket.tf_backend_s3_bucket,aws_s3_bucket_policy.tf_backend_s3_bucket_policy]
}
resource "aws_s3_bucket_policy" "tf_backend_s3_bucket_policy"{
  bucket = aws_s3_bucket.tf_backend_s3_bucket.id
  depends_on = [aws_s3_bucket.tf_backend_s3_bucket]
  policy = jsonencode({
    "Version": "2012-10-17",
    "Id": "tf_bucketpolicy",
    "Statement": [
        {
            "Sid": "allowiamrole",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${var.aws_role_arn}"
            },
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::${var.tf_backend_s3_bucket}/*"
        },
        {
            "Sid": "Stmt1625783799751",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${var.aws_role_arn}"
            },
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::${var.tf_backend_s3_bucket}"
        },
      {
        Sid       = "HTTPRestrict"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = "arn:aws:s3:::${var.tf_backend_s3_bucket}/*",
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      },
    ]
  })
}
#terraform s3 bucket and object configuration for managing terraform inputs
resource "aws_s3_bucket" "tf_inputs_s3_bucket" {
  bucket = var.tf_inputs_s3_bucket
  acl    = "private"
  force_destroy = true
  versioning {
    enabled = true
  }
  tags = local.tags
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
        kms_master_key_id = aws_kms_key.tf_backend_s3_bucket_kms_key.id
      }
    }
  }
}
resource "aws_s3_bucket_public_access_block" "tf_inputs_s3_bucket_public_access_block" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  bucket = aws_s3_bucket.tf_inputs_s3_bucket.id
  depends_on = [aws_s3_bucket.tf_inputs_s3_bucket,aws_s3_bucket_policy.tf_inputs_s3_bucket_policy]
}
resource "aws_s3_bucket_policy" "tf_inputs_s3_bucket_policy"{
  bucket = aws_s3_bucket.tf_inputs_s3_bucket.id
  depends_on = [aws_s3_bucket.tf_inputs_s3_bucket]
  policy = jsonencode({
    "Version": "2012-10-17",
    "Id": "tf_bucketpolicy",
    "Statement": [
        {
            "Sid": "allowiamrole",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${var.aws_role_arn}"
            },
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::${var.tf_inputs_s3_bucket}/*"
        },
        {
            "Sid": "Stmt1625783799751",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${var.aws_role_arn}"
            },
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::${var.tf_inputs_s3_bucket}"
        },
      {
        Sid       = "HTTPRestrict"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = "arn:aws:s3:::${var.tf_inputs_s3_bucket}/*",
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      },
    ]
  })
}
resource "aws_kms_key" "tf_dynamodb_table_kms_key" {
  description = "The KMS key used to encrypt dynamodb tables used for terraform state locking"
  deletion_window_in_days = 30
  key_usage = "ENCRYPT_DECRYPT"
  enable_key_rotation = true
  tags = local.tags
  policy = jsonencode({
    "Id": "key-consolepolicy-3",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "EnableIAMUserPermissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.aws_account_id}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "AllowaccessforKeyAdministrators",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${var.aws_role_arn}"
            },
            "Action": [
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
            "Resource": "*"
        },
        {
            "Sid": "Allowattachmentofpersistentresources",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${var.aws_role_arn}"
            },
            "Action": [
                "kms:CreateGrant",
                "kms:ListGrants",
                "kms:RevokeGrant"
            ],
            "Resource": "*",
            "Condition": {
                "Bool": {
                    "kms:GrantIsForAWSResource": "true"
                }
            }
        }
    ]
  })
}
resource "aws_dynamodb_table" "tf_state_lock" {
    for_each = toset(["${var.tf_backend_dynamodb_table_aws_resources}", "${var.tf_backend_dynamodb_table_k8s_resources}"])
    name = each.value
    billing_mode = "PROVISIONED"
    read_capacity = 5
    write_capacity = 5
    tags = local.tags
    hash_key = "LockID"
    server_side_encryption {
      enabled = true
      kms_key_arn = aws_kms_key.tf_dynamodb_table_kms_key.arn
    }
    attribute {
      name = "LockID"
      type = "S"
    }
    point_in_time_recovery {
      enabled = true
    }
}
