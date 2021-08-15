output "s3_bucket_arn" {
  value = aws_s3_bucket.tf_s3_bucket.arn
}
output "dynamodb_table_arn"{
  value = aws_dynamodb_table.tf_state_lock.arn
}
