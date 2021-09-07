#-----------------------------------------------------------------------------------------------------------------
#aws cognito application client outputs
output "cognito_user_pool_id" {
  value     = aws_cognito_user_pool.user_pool.id
  sensitive = true
}
output "cognito_app_client_id" {
  value     = aws_cognito_user_pool_client.cognito_app_client.id
  sensitive = true
}
output "cognito_client_secret" {
  value     = aws_cognito_user_pool_client.cognito_app_client.client_secret
  sensitive = true
}
#-----------------------------------------------------------------------------------------------------------------
#Route 53 hosted zones and endpoint information
output "aws_name_servers" {
  value       = (lookup(var.domain_info, "domain_registrar") == "others") ? aws_route53_zone.zones[0].name_servers : null
  description = "The list of name servers to be added into the registered domain with 3rd party registrar"
}
output "baf_user" {
  value = aws_iam_user.baf_automation.arn
}
output "baf_user_secret_key" {
  value = aws_iam_access_key.baf_automation_access_key.secret
  sensitive = true
}
#-----------------------------------------------------------------------------------------------------------------
#application cluster (EKS) outputs
output "app_cluster_endpoint" {
  value = module.app_eks_cluster.cluster_endpoint
}
#-----------------------------------------------------------------------------------------------------------------
#blockchain cluster (EKS) outputs
output "blk_cluster_endpoint" {
  value = module.blk_eks_cluster.cluster_endpoint
}
#-----------------------------------------------------------------------------------------------------------------
#cloudtrail related
output "cloudtrail_s3_bucket_name" {
  value = aws_s3_bucket.s3_bucket.bucket
}
