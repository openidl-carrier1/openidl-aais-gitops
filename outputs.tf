#application cluster vpc outputs
#-----------------------------------------------------------------------------------------------------------------
output "app_vpc_id" {
  value = module.aais_app_vpc.vpc_id
}
output "app_vpc_public_subnets" {
  value = module.aais_app_vpc.public_subnets
}
output "app_vpc_private_subnets" {
  value = module.aais_app_vpc.private_subnets
}
output "app_vpc_public_route_table_ids" {
  value = module.aais_app_vpc.public_route_table_ids
}
output "app_vpc_private_route_table_ids" {
  value = module.aais_app_vpc.private_route_table_ids
}
output "app_vpc_public_nacl_id" {
  value = module.aais_app_vpc.public_network_acl_id
}
output "app_vpc_private_nacl_id" {
  value = module.aais_app_vpc.private_network_acl_id
}
#-----------------------------------------------------------------------------------------------------------------
#blockchain cluster vpc outputs
output "blk_vpc_id" {
  value = module.aais_blk_vpc.vpc_id
}
output "blk_vpc_public_subnets" {
  value = module.aais_blk_vpc.public_subnets
}
output "blk_vpc_private_subnets" {
  value = module.aais_blk_vpc.private_subnets
}
output "blk_vpc_public_route_table_ids" {
  value = module.aais_blk_vpc.public_route_table_ids
}
output "blk_vpc_private_route_table_ids" {
  value = module.aais_blk_vpc.private_route_table_ids
}
output "blk_vpc_public_nacl_id" {
  value = module.aais_blk_vpc.public_network_acl_id
}
output "blk_vpc_private_nacl_id" {
  value = module.aais_blk_vpc.private_network_acl_id
}
#-----------------------------------------------------------------------------------------------------------------
#transit gateway results when created if aais environment or carrier environment in another aws region
output "app_tgw_ram_resource_share_id" {
  value = var.aais || (!var.aais && var.other_aws_account && var.other_aws_region) ? module.transit_gateway[0].ram_resource_share_id : null
  sensitive = true
}
output "app_tgw_id" {
  value = var.aais || (!var.aais && var.other_aws_account && var.other_aws_region) ? module.transit_gateway[0].ec2_transit_gateway_id : null
}
output "app_tgw_owner_id" {
  value = var.aais || (!var.aais && var.other_aws_account && var.other_aws_region) ? module.transit_gateway[0].ec2_transit_gateway_owner_id : null
  sensitive = true
}
output "app_tgw_ram_principal_association_id" {
  value = var.aais || (!var.aais && var.other_aws_account && var.other_aws_region) ? module.transit_gateway[0].ram_principal_association_id : null
  sensitive = true
}
#-----------------------------------------------------------------------------------------------------------------
#aws cognito application client outputs
output "cognito_user_pool_id" {
  value = aws_cognito_user_pool.user_pool.id
  sensitive = true
}
output "cognito_app_client_id" {
  value = aws_cognito_user_pool_client.cognito_app_client.id
  sensitive = true
}
output "cognito_client_secret" {
  value     = aws_cognito_user_pool_client.cognito_app_client.client_secret
  sensitive = true
}
output "cognito_userpool_endpoint" {
  value = aws_cognito_user_pool.user_pool.endpoint
  sensitive = true
}
output "cognito_userpool_arn" {
  value = aws_cognito_user_pool.user_pool.arn
  sensitive = true
}
#-----------------------------------------------------------------------------------------------------------------
#application cluster bastion host ssh key info
output "app_bastion_host_keypair_name" {
  value       = module.app_bastion_host_key_pair_external.key_pair_key_name
  sensitive = true
}
output "app_bastion_host_keypair_id" {
  value       = module.app_bastion_host_key_pair_external.key_pair_key_pair_id
  sensitive = true
}
output "app_bastion_nlb_fqdn" {
  value = module.app_bastion_nlb.lb_dns_name
}
#blockchain cluster bastion host ssh key info
output "blk_bastion_host_keypair_name" {
  value       = module.blk_bastion_host_key_pair_external.key_pair_key_name
  sensitive = true
}
output "blk_bastion_host_keypair_id" {
  value       = module.blk_bastion_host_key_pair_external.key_pair_key_pair_id
  sensitive = true
}
output "blk_bastion_nlb_fqdn" {
  value = module.blk_bastion_nlb.lb_dns_name
}
#-----------------------------------------------------------------------------------------------------------------
#application cluster public facing network load balancer fqdn
output "app_eks_nlb_fqdn" {
  value = module.app_eks_nlb.lb_dns_name
}
#blockchain cluster internal facing network load balancer fqdn
output "blk_eks_nlb_fqdn" {
  value = module.blk_eks_nlb.lb_dns_name
}
#application cluster worker nodes ssh key info
output "app_eks_worker_nodes_keypair_name" {
  value = module.app_eks_worker_nodes_key_pair_external.key_pair_key_name
  sensitive = true
}
output "app_eks_worker_nodes_keypair_id" {
  value = module.app_eks_worker_nodes_key_pair_external.key_pair_key_pair_id
  sensitive = true
}
#blockchain cluster worker nodes ssh key info
output "blk_eks_worker_nodes_keypair_name" {
  value = module.blk_eks_worker_nodes_key_pair_external.key_pair_key_name
  sensitive = true
}
output "blk_eks_worker_nodes_keypair_id" {
  value = module.blk_eks_worker_nodes_key_pair_external.key_pair_key_pair_id
  sensitive = true
}
#-----------------------------------------------------------------------------------------------------------------
#Route 53 hosted zones and endpoint information
output "aws_name_servers" {
  value = (lookup(var.domain_info, "domain_registrar") == "others") ? aws_route53_zone.zones[0].name_servers : null
  description = "The list of name servers to be added into the registered domain with 3rd party registrar"
}/*
output "app_alb_non_aws_registered_app_url" {
  value = lookup(var.domain_info, "domain_registrar") == "others" ? aws_route53_record.app_alb_r53_record_others[0].fqdn : null
  description = "The url to access the deployed application"
}
output "app_alb_aws_registration_due_app_url" {
  value = lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "no" ? aws_route53_record.app_alb_r53_record_aws_new_entry[0].fqdn : null
}
output "app_alb_aws_registered_app_url" {
 value = lookup(var.domain_info, "registered") == "yes" && lookup(var.domain_info, "domain_registrar") == "aws" ? aws_route53_record.app_alb_r53_record_aws_registered[0].fqdn : null
 description = "The url to access the deployed application"
}*/
output "app_nlb_non_aws_registered_app_url" {
  value = lookup(var.domain_info, "domain_registrar") == "others" ? aws_route53_record.app_nlb_r53_record_others[0].fqdn : null
  description = "The url to access the deployed application"
}
output "app_nlb_aws_registration_due_app_url" {
  value = lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "no" ? aws_route53_record.app_nlb_r53_record_aws_new_entry[0].fqdn : null
}
output "app_nlb_aws_registered_app_url" {
 value = lookup(var.domain_info, "registered") == "yes" && lookup(var.domain_info, "domain_registrar") == "aws" ? aws_route53_record.app_nlb_r53_record_aws_registered[0].fqdn : null
 description = "The url to access the deployed application"
}
output "route53_private_hosted_zone_id" {
  value = aws_route53_zone.aais_private_zones.zone_id
}
#-----------------------------------------------------------------------------------------------------------------
#S3 bucket output
output "s3_bucket_arn" {
  value = aws_s3_bucket.s3_bucket.arn
}
#-----------------------------------------------------------------------------------------------------------------
#application cluster (EKS) outputs
output "app_cluster_endpoint" {
  value       = module.app_eks_cluster.cluster_endpoint
}
output "app_cluster_cloudwatch_log_group_arn" {
  value       = module.app_eks_cluster.cloudwatch_log_group_arn
}
output "app_cluster_certificate_authority_data" {
  value       = module.app_eks_cluster.cluster_certificate_authority_data
  sensitive = true
}
output "app_cluster_iam_role_arn" {
  value       = module.app_eks_cluster.cluster_iam_role_arn
}
output "app_cluster_oidc_issuer_url" {
  value       = module.app_eks_cluster.cluster_oidc_issuer_url
}
output "app_cluster_primary_sg_id" {
  value       = module.app_eks_cluster.cluster_primary_security_group_id
}
output "app_cluster_sg_id" {
  value       = module.app_eks_cluster.cluster_security_group_id
}
output "app_cluster_kubeconfig" {
  value       = module.app_eks_cluster.kubeconfig
  sensitive = true
}
output "app_cluster_oidc_provider_arn" {
  value       = module.app_eks_cluster.oidc_provider_arn
}
output "app_cluster_worker_node_iam_role_arn" {
  value       = module.app_eks_cluster.worker_iam_role_arn
}
output "app_cluster_worker_node_sg_id" {
  value       = module.app_eks_cluster.worker_security_group_id
}
#-----------------------------------------------------------------------------------------------------------------
#blockchain cluster (EKS) outputs
output "blk_cluster_endpoint" {
  value       = module.blk_eks_cluster.cluster_endpoint
}
output "blk_cluster_cloudwatch_log_group_arn" {
  value       = module.blk_eks_cluster.cloudwatch_log_group_arn
}
output "blk_cluster_certificate_authority_data" {
  value       = module.blk_eks_cluster.cluster_certificate_authority_data
  sensitive = true
}
output "blk_cluster_iam_role_arn" {
  value       = module.blk_eks_cluster.cluster_iam_role_arn
}
output "blk_cluster_oidc_issuer_url" {
  value       = module.blk_eks_cluster.cluster_oidc_issuer_url
}
output "blk_cluster_primary_sg_id" {
  value       = module.blk_eks_cluster.cluster_primary_security_group_id
}
output "blk_cluster_sg_id" {
  value       = module.blk_eks_cluster.cluster_security_group_id
}
output "blk_cluster_kubeconfig" {
  value       = module.blk_eks_cluster.kubeconfig
  sensitive = true
}
output "blk_cluster_oidc_provider_arn" {
  value       = module.blk_eks_cluster.oidc_provider_arn
}
output "blk_cluster_worker_node_iam_role_arn" {
  value       = module.blk_eks_cluster.worker_iam_role_arn
}
output "blk_cluster_worker_node_sg_id" {
  value       = module.blk_eks_cluster.worker_security_group_id
}
#-----------------------------------------------------------------------------------------------------------------
#application cluster - application specific traffic rules - Security Group
output "app_cluster_sg_application_specific_traffic_rules" {
  value = module.app_eks_workers_app_traffic_sg.security_group_id
}
#blockchain cluster - application specific traffic rules - Security Group
output "blk_cluster_sg_application_specific_traffic_rules" {
  value = module.blk_eks_workers_app_traffic_sg.security_group_id
}
#-----------------------------------------------------------------------------------------------------------------


