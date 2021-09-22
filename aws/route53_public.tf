#creating public hosted zones
resource "aws_route53_zone" "zones" {
  count   = var.domain_info.r53_public_hosted_zone_required == "yes" ? 1 : 0
  name    = lookup(var.domain_info, "domain_name")
  comment = lookup(var.domain_info, "comments", null)
  tags = merge(
    local.tags,
    {
      "Name"         = "${var.domain_info.domain_name}"
      "Cluster_type" = "Both"
  }, )
}
resource "aws_route53_record" "app_nlb_r53_record" {
  count   = var.domain_info.r53_public_hosted_zone_required == "yes" ? 1 : 0
  zone_id = aws_route53_zone.zones[0].id
  name    = "openidl.${var.aws_env}.${var.domain_info.sub_domain_name}.${aws_route53_zone.zones[0].name}"
  type    = "A"
  alias {
    name                   = data.aws_alb.app_nlb.dns_name
    zone_id                = data.aws_alb.app_nlb.zone_id
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "app_nlb_bastion_r53_record" {
  count   = var.domain_info.r53_public_hosted_zone_required == "yes" ? 1 : 0
  zone_id = aws_route53_zone.zones[0].id
  name    = var.aws_env != "prod" ? "app-bastion.${var.aws_env}.${var.domain_info.sub_domain_name}.${aws_route53_zone.zones[0].name}" : "app-bastion.${var.domain_info.sub_domain_name}.${aws_route53_zone.zones[0].name}"
  type    = "A"
  alias {
    name                   = module.app_bastion_nlb.lb_dns_name
    zone_id                = module.app_bastion_nlb.lb_zone_id
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "blk_nlb_bastion_r53_record" {
  count   = var.domain_info.r53_public_hosted_zone_required == "yes" ? 1 : 0
  zone_id = aws_route53_zone.zones[0].id
  name    = var.aws_env != "prod" ? "blk-bastion.${var.aws_env}.${var.domain_info.sub_domain_name}.${aws_route53_zone.zones[0].name}" : "blk-bastion.${var.domain_info.sub_domain_name}.${aws_route53_zone.zones[0].name}"
  type    = "A"
  alias {
    name                   = module.blk_bastion_nlb.lb_dns_name
    zone_id                = module.blk_bastion_nlb.lb_zone_id
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "public_aais_orderorg_r53_record" {
  count   = var.domain_info.r53_public_hosted_zone_required == "yes" && var.org_name == "aais" ? 1 : 0
  zone_id = aws_route53_zone.zones[0].id
  name = var.aws_env != "prod" ? "*.ordererorg.${var.aws_env}.${var.domain_info.sub_domain_name}.${aws_route53_zone.zones[0].name}" : "*.ordererorg.${var.domain_info.sub_domain_name}.${aws_route53_zone.zones[0].name}"
  type = "A"
  alias {
    name                   = data.aws_alb.blk_nlb.dns_name
    zone_id                = data.aws_alb.blk_nlb.zone_id
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "public_common_r53_record" {
  count   = var.domain_info.r53_public_hosted_zone_required == "yes" ? 1 : 0
  zone_id = aws_route53_zone.zones[0].id
  name = var.aws_env != "prod" ? "*.${var.org_name}-net.${var.org_name}.${var.aws_env}.${var.domain_info.sub_domain_name}.${aws_route53_zone.zones[0].name}" : "*.${var.org_name}-net.${var.org_name}.${var.domain_info.sub_domain_name}.${aws_route53_zone.zones[0].name}"
  type = "A"
  alias {
    name                   = data.aws_alb.blk_nlb.dns_name
    zone_id                = data.aws_alb.blk_nlb.zone_id
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "public_data_call_r53_record" {
  count   = var.domain_info.r53_public_hosted_zone_required == "yes" ? 1 : 0
  zone_id = aws_route53_zone.zones[0].id
  name = var.aws_env != "prod" ? "data-call-app-service.${var.aws_env}.${var.domain_info.sub_domain_name}.${aws_route53_zone.zones[0].name}" : "data-call-app-service.${var.domain_info.sub_domain_name}.${aws_route53_zone.zones[0].name}"
  type = "A"
  alias {
    name                   = data.aws_alb.app_nlb.dns_name
    zone_id                = data.aws_alb.app_nlb.zone_id
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "public_insurance_manager_r53_record" {
  count   = var.domain_info.r53_public_hosted_zone_required == "yes" ? 1 : 0
  zone_id = aws_route53_zone.zones[0].id
  name = var.aws_env != "prod" ? "insurance-data-manager-service.${var.aws_env}.${var.domain_info.sub_domain_name}.${aws_route53_zone.zones[0].name}" : "insurance-data-manager-service.${var.domain_info.sub_domain_name}.${aws_route53_zone.zones[0].name}"
  type = "A"
  alias {
    name                   = data.aws_alb.app_nlb.dns_name
    zone_id                = data.aws_alb.app_nlb.zone_id
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "public_utilities_service_r53_record" {
  count   = var.domain_info.r53_public_hosted_zone_required == "yes" ? 1 : 0
  zone_id = aws_route53_zone.zones[0].id
  name = var.aws_env != "prod" ? "utilities-service.${var.aws_env}.${var.domain_info.sub_domain_name}.${aws_route53_zone.zones[0].name}" : "utilities-service.${var.domain_info.sub_domain_name}.${aws_route53_zone.zones[0].name}"
  type = "A"
  alias {
    name                   = data.aws_alb.app_nlb.dns_name
    zone_id                = data.aws_alb.app_nlb.zone_id
    evaluate_target_health = true
  }
}


