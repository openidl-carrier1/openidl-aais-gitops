output "app_vpc_id" {
  value = module.aais_vpc.vpc_id
}
output "app_vpc_public_subnets" {
  value = module.aais_vpc.public_subnets
}
output "app_vpc_private_subnets" {
  value = module.aais_vpc.private_subnets
}
/*
output "app_vpc_default_routetable_ids" {
  value = module.aais_vpc.default_route_table_id
}
output "app_vpc_public_routetable_ids" {
  value = module.aais_vpc.public_route_table_ids
}
output "app_vpc_private_routetable_ids" {
  value = module.aais_vpc.private_route_table_ids
}
output "app_vpc_default_nacl_id" {
  value = module.aais_vpc.default_network_acl_id
}*/
output "app_vpc_public_nacl_id" {
  value = module.aais_vpc.public_network_acl_id
}
output "app_vpc_private_nacl_id" {
  value = module.aais_vpc.private_network_acl_id
}
output "app_vpc_default_security_group" {
  value = module.aais_vpc.default_security_group_id
}
output "app_tgw_ram_resource_share_id" {
  value = var.cluster_type == "app_cluster" ? module.transit-gateway[*].ram_resource_share_id : null
  sensitive = true
}
output "app_tgw_id" {
  value = var.cluster_type == "app_cluster" ? module.transit-gateway[*].ec2_transit_gateway_id : null
}
output "app_tgw_route_table_id" {
  value = var.cluster_type == "app_cluster" ? module.transit-gateway[*].ec2_transit_gateway_route_table_id : null
}
output "app_tgw_owner_id" {
  value = var.cluster_type == "app_cluster" ? module.transit-gateway[*].ec2_transit_gateway_owner_id : null
  sensitive = true
}
output "app_tgw_ram_principal_association_id" {
  value = var.cluster_type == "app_cluster" ? module.transit-gateway[*].ram_principal_association_id : null
  sensitive = true
}
/*
output "app_tgw_vpc_attachment_ids" {
  value = var.cluster_type == "app_cluster" ? module.transit-gateway[*].ec2_transit_gateway_vpc_attachment_ids : null
}
*/
output "blockchain_tgw_ram_resource_share_id" {
  value = var.cluster_type == "blockchain_cluster" ? module.transit-gateway-peer[*].ram_resource_share_id : null
  sensitive = true
}
output "blockchain_tgw_id" {
  value = var.cluster_type == "blockchain_cluster" ? module.transit-gateway-peer[*].ec2_transit_gateway_id : null
}
output "blockchain_tgw_route_table_id" {
  value = var.cluster_type == "blockchain_cluster" ? module.transit-gateway-peer[*].ec2_transit_gateway_route_table_id : null
}
output "blockchain_tgw_owner_id" {
  value = var.cluster_type == "blockchain_cluster" ? module.transit-gateway-peer[*].ec2_transit_gateway_owner_id : null
  sensitive = true
}
output "blockchain_tgw_ram_principal_association_id" {
  value = var.cluster_type == "blockchain_cluster" ? module.transit-gateway-peer[*].ram_principal_association_id : null
  sensitive = true
}
output "blockchain_tgw_vpc_attachment_ids" {
  value = var.cluster_type == "blockchain_cluster" ? module.transit-gateway-peer[*].ec2_transit_gateway_vpc_attachment_ids : null
}
#aws cognito application client outputs
output "cognito_app_client_id" {
  value = var.cluster_type == "app_cluster" ? aws_cognito_user_pool_client.cognito_app_client[0].id : null
  sensitive = true
}
output "cognito_client_secret" {
  value     = var.cluster_type == "app_cluster" ? aws_cognito_user_pool_client.cognito_app_client[0].client_secret : null
  sensitive = true
}
output "cognito_userpool_id" {
  value = var.cluster_type == "app_cluster" ? aws_cognito_user_pool.user_pool[0].id : null
  sensitive = true
}
/*
output "cognito_userpool_domain_id" {
  value = var.cluster_type == "app_cluster" ? aws_cognito_user_pool_domain.domain[0].id : null
}*/
output "cognito_userpool_endpoint" {
  value = var.cluster_type == "app_cluster" ? aws_cognito_user_pool.user_pool[0].endpoint : null
  sensitive = true
}
output "cognito_userpool_arn" {
  value = var.cluster_type == "app_cluster" ? aws_cognito_user_pool.user_pool[0].arn : null
  sensitive = true
}
/*
output "ses_email_identity_arn" {
  value = aws_ses_email_identity.email_identity.arn
}
output "ses_email_identity_id" {
  value = aws_ses_email_identity.email_identity.id
}
*/
output "key_pair_key_name" {
  value       = module.key_pair_external.key_pair_key_name
  sensitive = true
}
output "key_pair_key_pair_id" {
  value       = module.key_pair_external.key_pair_key_pair_id
  sensitive = true
}
output "key_pair_fingerprint" {
  value       = module.key_pair_external.key_pair_fingerprint
  sensitive = true
}
output "bastion_nlb_dns_name" {
  value = module.bastion_nlb.lb_dns_name
}
output "aws_registered_app_url" {
 value = var.cluster_type == "app_cluster" && (lookup(var.domain_info, "registered") == "yes" && lookup(var.domain_info, "domain_registrar") == "aws") ? aws_route53_record.r53_record_aws_registered[0].fqdn : null
 description = "The url to access the deployed application"
}
output "aws_name_servers" {
  value = var.cluster_type == "app_cluster" && (lookup(var.domain_info, "domain_registrar") == "others") ? aws_route53_zone.zones[0].name_servers : null
  description = "The list of name servers to be added into the registered domain with 3rd party registrar"
}
output "non_aws_registered_app_url" {
  value = var.cluster_type == "app_cluster" && (lookup(var.domain_info, "domain_registrar") == "others") ? aws_route53_record.r53_record_others[0].fqdn : null
  description = "The url to access the deployed application"
}
output "aws_registration_due_app_url" {
  value = var.cluster_type == "app_cluster" && (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "no") ? aws_route53_record.r53_record_aws_new_entry[0].fqdn : null
}
/*
output "eks_workers_asg_arns" {
  description = "IDs of the autoscaling groups containing workers."
  value       = concat(module.app_eks.workers_asg_arns)

}
output "eks_cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster. On 1.14 or later, this is the 'Additional security groups' in the EKS console"
  value       = module.app_eks.cluster_security_group_id
}
output "eks_kubeconfig_contents" {
  description = "kubectl config file contents for this EKS cluster. Will block on cluster creation until the cluster is really ready."
  value       = module.app_eks.kubeconfig
  sensitive   = true
  depends_on = [
    module.app_eks,
  ]
}
output "eks_kubeconfig_filename" {
  description = "The filename of the generated kubectl config. Will block on cluster creation until the cluster is really ready."
  value       = module.app_eks.kubeconfig_filename
  depends_on = [
    module.app_eks,
  ]
}
############Kubernetes Dashboard############

output "eks_admin_token" {
  value     = var.create_admin_token ? lookup(data.kubernetes_secret.admin_token[0].data, "token") : "Not enabled"
  sensitive = true
}
output "eks_admin_service_account" {
  value = local.dashboard_admin_service_account
  sensitive = true
}
output "eks_namespace" {
  value = var.namespace
}
output "eks_dashboard_url" {
  value     = "${var.dashboard_subdomain}${var.domain}"
  sensitive = false
}
*/
output "eks_elb" {
  value = module.eks_alb.lb_dns_name
}