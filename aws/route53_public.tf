#creating public hosted zones
resource "aws_route53_zone" "zones" {
  count   = (lookup(var.domain_info, "domain_registrar") == "others" || ((lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "no"))) ? 1 : 0
  name    = lookup(var.domain_info, "domain_name")
  comment = lookup(var.domain_info, "comments", null)
  tags = merge(
    local.tags,
    {
      "Name"         = "${var.domain_info.domain_name}"
      "Cluster_type" = "application"
  }, )
}
#adding route53 entry in the hosted zone when domain is already registered in aws route53 for app cluster NLB
resource "aws_route53_record" "app_nlb_r53_record_registered_in_aws" {
  count   = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "yes") ? 1 : 0
  zone_id = data.aws_route53_zone.data_zones[0].id
  name    = "openidl.${var.org_name}.${var.aws_env}.${data.aws_route53_zone.data_zones[0].name}"
  type    = "A"
  alias {
    name                   = data.aws_alb.app_nlb.dns_name
    zone_id                = data.aws_alb.app_nlb.zone_id
    evaluate_target_health = true
  }
}
#adding route53 entry in the hosted zone when domain is yet to register in aws route53 or registered outside for app cluster NLB
resource "aws_route53_record" "app_nlb_r53_record_new_entry" {
  count   = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "no") || lookup(var.domain_info, "domain_registrar") == "others" ? 1 : 0
  zone_id = aws_route53_zone.zones[0].id
  name    = "openidl.${var.org_name}.${var.aws_env}.${aws_route53_zone.zones[0].name}"
  type    = "A"
  alias {
    name                   = data.aws_alb.app_nlb.dns_name
    zone_id                = data.aws_alb.app_nlb.zone_id
    evaluate_target_health = true
  }
}
#adding route53 entry in the hosted zone when domain is already registered in aws route53 for app vpc nlb fronting bastion host
resource "aws_route53_record" "app_nlb_bastion_r53_record_registered_in_aws" {
  count   = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "yes") ? 1 : 0
  zone_id = data.aws_route53_zone.data_zones[0].id
  name    = "app-bastion.${var.org_name}.${data.aws_route53_zone.data_zones[0].name}"
  type    = "A"
  alias {
    name                   = module.app_bastion_nlb.lb_dns_name
    zone_id                = module.app_bastion_nlb.lb_zone_id
    evaluate_target_health = true
  }
}
#adding route53 entry in the hosted zone when domain is yet to register in aws or registered outside for app vpc nlb fronting bastion host
resource "aws_route53_record" "app_nlb_bastion_r53_record_new_entry" {
  count   = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "no") || lookup(var.domain_info, "domain_registrar") == "others" ? 1 : 0
  zone_id = aws_route53_zone.zones[0].id
  name    = "app-bastion.${var.org_name}.${aws_route53_zone.zones[0].name}"
  type    = "A"
  alias {
    name                   = module.app_bastion_nlb.lb_dns_name
    zone_id                = module.app_bastion_nlb.lb_zone_id
    evaluate_target_health = true
  }
}
#adding route53 entry in the hosted zone when domain is already registered in aws route53 for blk vpc nlb fronting bastion host
resource "aws_route53_record" "blk_nlb_bastion_r53_record_registered_in_aws" {
  count   = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "yes") ? 1 : 0
  zone_id = data.aws_route53_zone.data_zones[0].id
  name    = "blk-bastion.${var.org_name}.${data.aws_route53_zone.data_zones[0].name}"
  type    = "A"
  alias {
    name                   = module.blk_bastion_nlb.lb_dns_name
    zone_id                = module.blk_bastion_nlb.lb_zone_id
    evaluate_target_health = true
  }
}
#adding route53 entry in the hosted zone when domain is yet to register in aws or registered outside for blk vpc nlb fronting bastion host
resource "aws_route53_record" "blk_nlb_bastion_r53_record_new_entry" {
  count   = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "no") || lookup(var.domain_info, "domain_registrar") == "others" ? 1 : 0
  zone_id = aws_route53_zone.zones[0].id
  name    = "blk-bastion.${var.org_name}.${aws_route53_zone.zones[0].name}"
  type    = "A"
  alias {
    name                   = module.blk_bastion_nlb.lb_dns_name
    zone_id                = module.blk_bastion_nlb.lb_zone_id
    evaluate_target_health = true
  }
}
#public route53 entries for aais specific related to orderorg and orderorg-net-aws registered
resource "aws_route53_record" "public_aais_orderorg_reg_in_aws" {
  count   = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "yes") && var.node_type == "aais" ? 1 : 0
  zone_id = data.aws_route53_zone.data_zones[0].id
  name = var.aws_env != "prod" ? "*.ordererorg.${var.aws_env}.${var.domain_info.domain_name}" : "*.ordererorg.${var.domain_info.domain_name}"
  type = "A"
  alias {
    name                   = data.aws_alb.blk_nlb.dns_name
    zone_id                = data.aws_alb.blk_nlb.zone_id
    evaluate_target_health = true
  }
}
#public route53 entries for aais specific related to orderorg and orderorg-net-outside registered
resource "aws_route53_record" "public_aais_orderorg_new_entry" {
  count   = ((lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "no") && var.node_type == "aais") || (lookup(var.domain_info, "domain_registrar") == "others" && var.node_type == "aais") ? 1 : 0
  zone_id = aws_route53_zone.zones[0].id
  name = var.aws_env != "prod" ? "*.ordererorg.${var.aws_env}.${var.domain_info.domain_name}" : "*.ordererorg.${var.domain_info.domain_name}"
  type = "A"
  alias {
    name                   = data.aws_alb.blk_nlb.dns_name
    zone_id                = data.aws_alb.blk_nlb.zone_id
    evaluate_target_health = true
  }
}
/*
#public route53 entries for aais specific related to orderorg and orderorg-net-aws registered
resource "aws_route53_record" "public_aais_orderorg-net_reg_in_aws" {
  count   = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "yes") && var.node_type == "aais" ? 1 : 0
  zone_id = data.aws_route53_zone.data_zones[0].id
  name = var.aws_env != "prod" ? "${var.aws_env}-*.ordererorg-net.ordererorg.${var.domain_info.domain_name}" : "*.ordererorg-net.ordererorg.${var.domain_info.domain_name}"
  type = "A"
  alias {
    name                   = data.aws_alb.blk_nlb.dns_name
    zone_id                = data.aws_alb.blk_nlb.zone_id
    evaluate_target_health = true
  }
}
#public route53 entries for aais specific related to orderorg and orderorg-net-outside registered
resource "aws_route53_record" "public_aais_orderorg-net_new_entry" {
  count   = ((lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "no") && var.node_type == "aais") || (lookup(var.domain_info, "domain_registrar") == "others" && var.node_type == "aais") ? 1 : 0
  zone_id = aws_route53_zone.zones[0].id
  name = var.aws_env != "prod" ? "${var.aws_env}-*.ordererorg-net.ordererorg.${var.domain_info.domain_name}" : "*.ordererorg-net.ordererorg.${var.domain_info.domain_name}"
  type = "A"
  alias {
    name                   = data.aws_alb.blk_nlb.dns_name
    zone_id                = data.aws_alb.blk_nlb.zone_id
    evaluate_target_health = true
  }
}
*/
#public route53 entries for all node types-aws registered
resource "aws_route53_record" "public_common_reg_in_aws" {
  count   = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "yes") ? 1 : 0
  zone_id = data.aws_route53_zone.data_zones[0].id
  name = var.aws_env != "prod" ? "*.${var.org_name}-net.${var.org_name}.${var.aws_env}.${var.domain_info.domain_name}" : "*.${var.org_name}-net.${var.org_name}.${var.domain_info.domain_name}"
  type = "A"
  alias {
    name                   = data.aws_alb.blk_nlb.dns_name
    zone_id                = data.aws_alb.blk_nlb.zone_id
    evaluate_target_health = true
  }
}
#public route53 entries for all node types-outside registered
resource "aws_route53_record" "public_common_new_entry" {
  count   = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "no")  || (lookup(var.domain_info, "domain_registrar") == "others") ? 1 : 0
  zone_id = aws_route53_zone.zones[0].id
  name = var.aws_env != "prod" ? "*.${var.org_name}-net.${var.org_name}.${var.aws_env}.${var.domain_info.domain_name}" : "*.${var.org_name}-net.${var.org_name}.${var.domain_info.domain_name}"
  type = "A"
  alias {
    name                   = data.aws_alb.blk_nlb.dns_name
    zone_id                = data.aws_alb.blk_nlb.zone_id
    evaluate_target_health = true
  }
}
#public route entries for data call app and insurance data mgr services
resource "aws_route53_record" "public_data_call_reg_in_aws" {
  count   = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "yes") ? 1 : 0
  zone_id = data.aws_route53_zone.data_zones[0].id
  name = var.aws_env != "prod" ? "data-call-app-service.${var.org_name}.${var.aws_env}.${var.domain_info.domain_name}" : "data-call-app-service.${var.org_name}.${var.aws_env}.${var.domain_info.domain_name}"
  type = "A"
  alias {
    name                   = data.aws_alb.app_nlb.dns_name
    zone_id                = data.aws_alb.app_nlb.zone_id
    evaluate_target_health = true
  }
}
#public route53 entries for all node types-outside registered
resource "aws_route53_record" "public_data_call_new_entry" {
  count   = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "no")  || (lookup(var.domain_info, "domain_registrar") == "others") ? 1 : 0
  zone_id = aws_route53_zone.zones[0].id
  name = var.aws_env != "prod" ? "data-call-app-service.${var.org_name}.${var.aws_env}.${var.domain_info.domain_name}" : "data-call-app-service.${var.org_name}.${var.aws_env}.${var.domain_info.domain_name}"
  type = "A"
  alias {
    name                   = data.aws_alb.app_nlb.dns_name
    zone_id                = data.aws_alb.app_nlb.zone_id
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "public_insurance_manager_reg_in_aws" {
  count   = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "yes") ? 1 : 0
  zone_id = data.aws_route53_zone.data_zones[0].id
  name = var.aws_env != "prod" ? "insurance-data-manager-service.${var.org_name}.${var.aws_env}.${var.domain_info.domain_name}" : "insurance-data-manager-service.${var.org_name}.${var.aws_env}.${var.domain_info.domain_name}"
  type = "A"
  alias {
    name                   = data.aws_alb.app_nlb.dns_name
    zone_id                = data.aws_alb.app_nlb.zone_id
    evaluate_target_health = true
  }
}
#public route53 entries for all node types-outside registered
resource "aws_route53_record" "public_insurance_manager_new_entry" {
  count   = (lookup(var.domain_info, "domain_registrar") == "aws" && lookup(var.domain_info, "registered") == "no")  || (lookup(var.domain_info, "domain_registrar") == "others") ? 1 : 0
  zone_id = aws_route53_zone.zones[0].id
  name = var.aws_env != "prod" ? "insurance-data-manager-service.${var.org_name}.${var.aws_env}.${var.domain_info.domain_name}" : "insurance-data-manager-service.${var.org_name}.${var.aws_env}.${var.domain_info.domain_name}"
  type = "A"
  alias {
    name                   = data.aws_alb.app_nlb.dns_name
    zone_id                = data.aws_alb.app_nlb.zone_id
    evaluate_target_health = true
  }
}



