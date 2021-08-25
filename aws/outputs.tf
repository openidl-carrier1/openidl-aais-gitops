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
#bastion host route53 related
output "app_bastion_nlb_private_endpoint" {
  value = var.bastion_host_nlb_external ? null : aws_route53_record.private_record_app_nlb_bastion[0].fqdn
}
output "blk_bastion_nlb_private_endpoint" {
  value = var.bastion_host_nlb_external ? null : aws_route53_record.private_record_blk_nlb_bastion[0].fqdn
}
output "app_bastion_nlb_public_endpoint" {
  value = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "yes") ? aws_route53_record.app_nlb_bastion_r53_record_registered_in_aws[0].fqdn : null
}
output "app_bastion_host_nlb_public_endpoint" {
  value = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "no") || lookup(var.domain_info, "domain_registrar") == "others" ? aws_route53_record.app_nlb_bastion_r53_record_new_entry[0].fqdn : null
}
output "blk_bastion_nlb_public_endpoint" {
  value = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "yes") ? aws_route53_record.blk_nlb_bastion_r53_record_registered_in_aws[0].fqdn : null
}
output "blk_bastion_host_nlb_public_endpoint" {
  value = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "no") || lookup(var.domain_info, "domain_registrar") == "others" ? aws_route53_record.blk_nlb_bastion_r53_record_new_entry[0].fqdn : null
}
output "private_endpoint_couchdb" {
  value = aws_route53_record.private_databases["couchdb"].fqdn
}
output "private_endpoint_mongodb" {
  value = aws_route53_record.private_databases["mongodb"].fqdn
}
output "private_endpoint_vault" {
  value = aws_route53_record.private_vault.fqdn
}
output "private_endpoint_blk_nlb" {
  value = aws_route53_record.private_common.fqdn
}
output "private_endpoint_ordererorg" {
  value = var.node_type == "aais" ? aws_route53_record.private_aais["ordererorg"].fqdn : null
}
output "private_endpoint_ordererorg-net" {
  value = var.node_type == "aais" ? aws_route53_record.private_aais["ordererorg-net.ordererorg"].fqdn : null
}
output "public_endpoint_blk_nlb" {
  value = ((lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "no") && var.node_type == "aais") || (lookup(var.domain_info, "domain_registrar") == "others" && var.node_type == "aais") ? aws_route53_record.public_common_new_entry[0].fqdn : null
}
output "public_endpoint_nlb_blk" {
  value = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "yes") && var.node_type == "aais" ? aws_route53_record.public_common_reg_in_aws[0].fqdn : null
}
output "public_endpoint-ordererorg-net" {
  value = ((lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "no") && var.node_type == "aais") || (lookup(var.domain_info, "domain_registrar") == "others" && var.node_type == "aais") ? aws_route53_record.public_aais_orderorg-net_new_entry[0].fqdn : null
}
output "public_endpoint_ordererorg-net" {
  value = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "yes") && var.node_type == "aais" ? aws_route53_record.public_aais_orderorg-net_reg_in_aws[0].fqdn : null
}
output "public_endpoint-ordererorg" {
  value = ((lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "no") && var.node_type == "aais") || (lookup(var.domain_info, "domain_registrar") == "others" && var.node_type == "aais") ? aws_route53_record.public_aais_orderorg_new_entry[0].fqdn : null
}
output "public_endpoint_ordererorg" {
  value = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "yes") && var.node_type == "aais" ? aws_route53_record.public_aais_orderorg_reg_in_aws[0].fqdn : null
}
output "public_endpoint_UI" {
  value = ((lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "no") && var.node_type == "aais") || (lookup(var.domain_info, "domain_registrar") == "others" && var.node_type == "aais") ? aws_route53_record.app_nlb_r53_record_new_entry[0].fqdn : null
}
output "public_endpoint-UI" {
  value = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "yes") && var.node_type == "aais" ? aws_route53_record.app_nlb_r53_record_registered_in_aws[0].fqdn : null
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
#application dns endpoint
output "application_UI_endpoint" {
  value = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "no") || lookup(var.domain_info, "domain_registrar") == "others" ? aws_route53_record.app_nlb_r53_record_new_entry[0].fqdn : null
}
output "application_user_interface_endpoint" {
  value = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "yes") ? aws_route53_record.app_nlb_r53_record_registered_in_aws[0].fqdn : null
}