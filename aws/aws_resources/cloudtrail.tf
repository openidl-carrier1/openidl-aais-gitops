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