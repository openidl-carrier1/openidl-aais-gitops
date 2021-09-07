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
#-----------------------------------------------------------------------------------------------------------------
#Route53 private entries
output "private_app_bastion_nlb_private_fqdn" {
  value = var.bastion_host_nlb_external ? null : aws_route53_record.private_record_app_nlb_bastion[0].fqdn
}
output "private_blk_bastion_nlb_private_fqdn" {
  value = var.bastion_host_nlb_external ? null : aws_route53_record.private_record_blk_nlb_bastion[0].fqdn
}
output "private_data_call_service_fqdn" {
  value = aws_route53_record.private_services["data-call-app-service"].fqdn
}
output "private_insurance_manager_service_fqdn" {
  value = aws_route53_record.private_services["insurance-data-manager-service"].fqdn
}
output "private_vault_fqdn" {
  value = aws_route53_record.private_vault.fqdn
}
output "private_ordererorg_fqdn" {
  value = var.node_type == "aais" ? aws_route53_record.private_aais["*.ordererorg"].fqdn : null
}
output "private_ca-ordererorg-net_fqdn" {
  value = var.node_type == "aais" ? aws_route53_record.private_aais["ca.ordererorg-net"].fqdn : null
}
output "private_ca-aais-net_fqdn" {
  value = var.node_type == "aais" ? aws_route53_record.private_aais["ca.aais-net"].fqdn : null
}
output "private_common_fqdn" {
  value = aws_route53_record.private_common.fqdn
}
#Route53 public entries
output "public_insurance_manager_service_fqdn" {
  value = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "no")  || (lookup(var.domain_info, "domain_registrar") == "others") ? aws_route53_record.public_insurance_manager_new_entry[0].fqdn : null
}
output "public_insurance_manager_service_dns_entry" {
  value = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "yes") ? aws_route53_record.public_insurance_manager_reg_in_aws[0].fqdn : null
}
output "public_data_call_service_fqdn" {
  value = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "no")  || (lookup(var.domain_info, "domain_registrar") == "others") ? aws_route53_record.public_data_call_new_entry[0].fqdn : null
}
output "public_data_call_service_dns_entry" {
  value = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "yes") ? aws_route53_record.public_data_call_reg_in_aws[0].fqdn : null
}
output "public_common_fqdn" {
  value = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "no")  || (lookup(var.domain_info, "domain_registrar") == "others") ? aws_route53_record.public_common_new_entry[0].fqdn : null
}
output "public_common_dns_entry" {
  value = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "yes") ? aws_route53_record.public_common_reg_in_aws[0].fqdn : null
}
output "public_ordererog_fqdn" {
  value = ((lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "no") && var.node_type == "aais") || (lookup(var.domain_info, "domain_registrar") == "others" && var.node_type == "aais") ? aws_route53_record.public_aais_orderorg_new_entry[0].fqdn : null
}
output "public_ordererorg_dns_entry" {
  value = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "yes") && var.node_type == "aais" ? aws_route53_record.public_aais_orderorg_reg_in_aws[0].fqdn : null
}
output "public_blk_bastion_fqdn" {
  value = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "no") || lookup(var.domain_info, "domain_registrar") == "others" ? aws_route53_record.blk_nlb_bastion_r53_record_new_entry[0].fqdn : null
}
output "public_blk_bastion_dns_entry" {
  value =  (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "yes") ? aws_route53_record.blk_nlb_bastion_r53_record_registered_in_aws[0].fqdn : null
}
output "public_app_bastion_fqdn" {
  value = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "no") || lookup(var.domain_info, "domain_registrar") == "others" ? aws_route53_record.app_nlb_bastion_r53_record_new_entry[0].fqdn : null
}
output "public_app_bastion_dns_entry" {
  value =  (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "yes") ? aws_route53_record.app_nlb_bastion_r53_record_registered_in_aws[0].fqdn : null
}
output "public_app_url" {
  value = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "no") || lookup(var.domain_info, "domain_registrar") == "others" ? aws_route53_record.app_nlb_r53_record_new_entry[0].fqdn : null
}
output "public_app_ui_url" {
  value = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "yes") ? aws_route53_record.app_nlb_r53_record_registered_in_aws[0].fqdn : null
}

