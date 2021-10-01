#Route53 private entries
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
#Route53 public entries
output "public_app_ui_url" {
  value = var.domain_info.r53_public_hosted_zone_required == "yes" ? aws_route53_record.app_nlb_r53_record[0].fqdn : null
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
