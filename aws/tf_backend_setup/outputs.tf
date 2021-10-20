output "s3_bucket_arn_terraform_backend" {
  value = aws_s3_bucket.tf_backend_s3_bucket.arn
}
output "s3_bucket_arn_terraform_inputs" {
  value = aws_s3_bucket.tf_inputs_s3_bucket.arn
}
output "dynamodb_table_arn_aws_resources"{
  value = aws_dynamodb_table.tf_state_lock["${var.tf_backend_dynamodb_table_aws_resources}"].arn
}
output "dynamodb_table_arn_k8s_resources"{
  value = aws_dynamodb_table.tf_state_lock["${var.tf_backend_dynamodb_table_k8s_resources}"].arn
}

