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
output "git_actions_iam_user" {
  value = aws_iam_user.git_actions_user.arn
}
output "git_actions_iam_user_access_key" {
  value = aws_iam_access_key.git_actions_access_key.id
  sensitive = true
}
output "git_actions_iam_user_secret_key" {
  value = aws_iam_access_key.git_actions_access_key.secret
  sensitive = true
}
output "baf_automation_user" {
  value = aws_iam_user.baf_user.arn
}
output "baf_automation_user_access_key" {
  value = aws_iam_access_key.baf_user_access_key.id
  sensitive = true
}
output "baf_automation_user_secret_key" {
  value = aws_iam_access_key.baf_user_access_key.secret
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
#-----------------------------------------------------------------------------------------------------------------
#Route53 private entries
output "private_app_bastion_nlb_private_fqdn" {
  value = var.bastion_host_nlb_external ? null : aws_route53_record.private_record_app_nlb_bastion[0].fqdn
}
output "private_blk_bastion_nlb_private_fqdn" {
  value = var.bastion_host_nlb_external ? null : aws_route53_record.private_record_blk_nlb_bastion[0].fqdn
}
output "private_data_call_service_fqdn" {
  value = aws_route53_record.private_record_services["data-call-app-service"].fqdn
}
output "private_insurance_manager_service_fqdn" {
  value = aws_route53_record.private_record_services["insurance-data-manager-service"].fqdn
}
output "private_vault_fqdn" {
  value = aws_route53_record.private_record_vault.fqdn
}
output "private_ordererorg_fqdn" {
  value = var.org_name == "aais" ? aws_route53_record.private_record_aais["*.ordererorg"].fqdn : null
}
output "private_ca-ordererorg-net_fqdn" {
  value = var.org_name == "aais" ? aws_route53_record.private_record_aais["ca.ordererorg-net.ordererorg"].fqdn : null
}
output "private_ca-aais-net_fqdn" {
  value = var.org_name == "aais" ? aws_route53_record.private_record_aais["ca.aais-net.aais"].fqdn : null
}
output "private_common_fqdn" {
  value = aws_route53_record.private_record_common.fqdn
}
#Route 53 hosted zones and endpoint information
output "aws_name_servers" {
  value       = var.domain_info.r53_public_hosted_zone_required == "yes"  ? aws_route53_zone.zones[0].name_servers : null
  description = "The name servers to be updated in the domain registrar"
}
#Route53 public entries
output "public_app_ui_url" {
  value = var.domain_info.r53_public_hosted_zone_required == "yes" ? aws_route53_record.app_nlb_r53_record[0].fqdn : null
}
output "public_blk_bastion_fqdn" {
  value = var.domain_info.r53_public_hosted_zone_required == "yes" ? aws_route53_record.blk_nlb_bastion_r53_record[0].fqdn : null
}
output "public_app_bastion_fqdn" {
  value = var.domain_info.r53_public_hosted_zone_required == "yes" ? aws_route53_record.app_nlb_bastion_r53_record[0].fqdn : null
}
output "public_ordererog_fqdn" {
  value = var.domain_info.r53_public_hosted_zone_required == "yes" && var.org_name == "aais" ? aws_route53_record.public_aais_orderorg_r53_record[0].fqdn : null
}
output "public_common_fqdn" {
  value = var.domain_info.r53_public_hosted_zone_required == "yes" ? aws_route53_record.public_common_r53_record[0].fqdn : null
}
output "public_data_call_service_fqdn" {
  value = var.domain_info.r53_public_hosted_zone_required == "yes" ? aws_route53_record.public_data_call_r53_record[0].fqdn : null
}
output "public_insurance_manager_service_fqdn" {
  value = var.domain_info.r53_public_hosted_zone_required == "yes" ? aws_route53_record.public_insurance_manager_r53_record[0].fqdn : null
}
output "public_utilities_service_fqdn" {
  value = var.domain_info.r53_public_hosted_zone_required == "yes" ? aws_route53_record.public_utilities_service_r53_record[0].fqdn : null
}
output "dns_entries_required_to_update" {
  value = var.domain_info.r53_public_hosted_zone_required == "no" && var.aws_env == "prod" ? local.dns_entries_list_prod : null
}
output "dns_entries_required_to_add" {
  value = var.domain_info.r53_public_hosted_zone_required == "no" && var.aws_env != "prod" ? local.dns_entries_list_non_prod : null
}
output "secret_manager_vault_secret_arn" {
  value = aws_secretsmanager_secret.vault_secret.arn
}

