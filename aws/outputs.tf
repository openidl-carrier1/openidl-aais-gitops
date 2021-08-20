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
#bastion host nlb fqdn
output "app_bastion_nlb_fqdn" {
  value = module.app_bastion_nlb.lb_dns_name
}
output "blk_bastion_nlb_fqdn" {
  value = module.blk_bastion_nlb.lb_dns_name
}
#-----------------------------------------------------------------------------------------------------------------
#Route 53 hosted zones and endpoint information
output "aws_name_servers" {
  value       = (lookup(var.domain_info, "domain_registrar") == "others") ? aws_route53_zone.zones[0].name_servers : null
  description = "The list of name servers to be added into the registered domain with 3rd party registrar"
}
/*
output "route53_private_blk_nlb_internal_dns_mappings" {
  value = aws_route53_record.aais_private_records[*].fqdn
}
output "route53_public_app_nlb_external_dns_mapping" {
  value = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "yes") ? aws_route53_record.app_nlb_r53_record_registered_in_aws[0].fqdn : null
}
output "route53_public_app_nlb_external_dns_map" {
  value = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "no") || lookup(var.domain_info, "domain_registrar") == "others" ? aws_route53_record.app_nlb_r53_record_new_entry[0].fqdn : null
}
output "route53_public_blk_nlb_external_dns_mapping" {
  value = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "yes") ? aws_route53_record.blk_nlb_r53_record_registered_in_aws[*].fqdn : null
}
output "route53_public_blk_nlb_external_dns_map" {
  value = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "no") || lookup(var.domain_info, "domain_registrar") == "others" ? aws_route53_record.blk_nlb_r53_record_new_entry[*].fqdn : null
}
*/
#bastion host route53 related
output "route53_private_app_nlb_bastion_fqdn" {
  value = var.bastion_host_nlb_external ? null : aws_route53_record.private_record_app_nlb_bastion[0].fqdn
}
output "route53_private_blk_nlb_bastion_fqdn" {
  value = var.bastion_host_nlb_external ? null : aws_route53_record.private_record_blk_nlb_bastion[0].fqdn
}
output "route53_public_app_nlb_bastion_dns_mapping" {
  value = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "yes") ? aws_route53_record.app_nlb_bastion_r53_record_registered_in_aws[0].fqdn : null
}
output "route53_public_app_nlb_bastion_dns_map" {
  value = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "no") || lookup(var.domain_info, "domain_registrar") == "others" ? aws_route53_record.app_nlb_bastion_r53_record_new_entry[0].fqdn : null
}
output "route53_public_blk_nlb_bastion_dns_mapping" {
  value = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "yes") ? aws_route53_record.blk_nlb_bastion_r53_record_registered_in_aws[0].fqdn : null
}
output "route53_public_blk_nlb_bastion_dns_map" {
  value = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "no") || lookup(var.domain_info, "domain_registrar") == "others" ? aws_route53_record.blk_nlb_bastion_r53_record_new_entry[0].fqdn : null
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
#application cluster - application specific traffic rules - Security Group
output "app_cluster_application_specific_traffic_rules_sec_group" {
  value = module.app_eks_workers_app_traffic_sg.security_group_id
}
#blockchain cluster - application specific traffic rules - Security Group
output "blk_cluster_application_specific_traffic_rules_sec_group" {
  value = module.blk_eks_workers_app_traffic_sg.security_group_id
}
#-----------------------------------------------------------------------------------------------------------------
#cloudtrail related
output "cloudtrail_s3_bucket_name" {
  value = aws_s3_bucket.s3_bucket.bucket
}


