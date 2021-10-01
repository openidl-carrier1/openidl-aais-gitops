output "s3_bucket_arn_terraform_backend" {
  value = aws_s3_bucket.tf_s3_bucket.arn
}
output "s3_bucket_arn_terraform_inputs" {
  value = aws_s3_bucket.tf_inputs_s3_bucket.arn
}
output "aws_resources_dynamodb_table_arn"{
  value = aws_dynamodb_table.tf_state_lock["${var.tf_backend_dynamodb_table_aws_resources}"].arn
}
output "k8s_resources_dynamodb_table_arn"{
  value = aws_dynamodb_table.tf_state_lock["${var.tf_backend_dynamodb_table_k8s_resources}"].arn
}

