#creating private hosted zones for internal vpc dns resolution - databases and vault
resource "aws_route53_zone" "aais_private_zones_internal" {
  name    = "internal.${var.domain_info.domain_name}"
  comment = "Private hosted zones for dns resolution"
  vpc {
    vpc_id = module.aais_app_vpc.vpc_id
  }
  vpc {
    vpc_id = module.aais_blk_vpc.vpc_id
  }
  tags = merge(
    local.tags,
    {
      "Name"         = "${local.std_name}-internal.${var.domain_info.domain_name}"
      "Cluster_type" = "both"
  },)
}
#creating private hosted zones for internal vpc dns resolution - others
resource "aws_route53_zone" "aais_private_zones" {
  name    = "${var.domain_info.domain_name}"
  comment = "Private hosted zones for dns resolution"
  vpc {
    vpc_id = module.aais_app_vpc.vpc_id
  }
  vpc {
    vpc_id = module.aais_blk_vpc.vpc_id
  }
  tags = merge(
    local.tags,
    {
      "Name"         = "${local.std_name}-${var.domain_info.domain_name}"
      "Cluster_type" = "both"
  },)
}
#setting up private dns entries for app bastion host nlb
resource "aws_route53_record" "private_record_app_nlb_bastion" {
  count = var.bastion_host_nlb_external ? 0 : 1
  zone_id = aws_route53_zone.aais_private_zones.zone_id
  name = "app-bastion.${var.org_name}"
  type    = "A"
  alias {
    name                   = module.app_bastion_nlb.lb_dns_name
    zone_id                = module.app_bastion_nlb.lb_zone_id
    evaluate_target_health = true
  }
}
#setting up private dns entries for blk bastion host nlb
resource "aws_route53_record" "private_record_blk_nlb_bastion" {
  count = var.bastion_host_nlb_external ? 0 : 1
  zone_id = aws_route53_zone.aais_private_zones.zone_id
  name = "blk-bastion.${var.org_name}"
  type    = "A"
  alias {
    name                   = module.blk_bastion_nlb.lb_dns_name
    zone_id                = module.blk_bastion_nlb.lb_zone_id
    evaluate_target_health = true
  }
}
#setting up private dns entries for data call and insurance data manager services
resource "aws_route53_record" "private_services" {
  for_each = toset(["data-call-app-service", "insurance-data-manager-service"])
  zone_id = aws_route53_zone.aais_private_zones_internal.zone_id
  name = var.aws_env != "prod" ? "${each.value}.${var.org_name}.${var.aws_env}" : "${each.value}.${var.org_name}"
  type    = "A"
  alias {
    name                   = data.aws_alb.app_nlb.dns_name
    zone_id                = data.aws_alb.app_nlb.zone_id
    evaluate_target_health = true
  }
}
#setting up private dns entries for vault
resource "aws_route53_record" "private_vault" {
  zone_id = aws_route53_zone.aais_private_zones_internal.zone_id
  name = var.aws_env != "prod" ? "vault.${var.org_name}.${var.aws_env}" : "vault.${var.org_name}"
  type    = "A"
  alias {
    name                   = data.aws_alb.blk_nlb.dns_name
    zone_id                = data.aws_alb.blk_nlb.zone_id
    evaluate_target_health = true
  }
}
#setting up private dns entries on aais nodes specific
resource "aws_route53_record" "private_aais" {
  for_each = {for k in ["*.ordererorg", "ca.ordererorg-net", "ca.aais-net"] : k => k if var.node_type == "aais" }
  name = var.aws_env != "prod" ? "${each.value}.${var.aws_env}" : "${each.value}"
  type = "A"
  zone_id = aws_route53_zone.aais_private_zones.zone_id
  alias {
    evaluate_target_health = true
    name = data.aws_alb.blk_nlb.dns_name
    zone_id = data.aws_alb.blk_nlb.zone_id
  }
}
#setting up private dns entries common for all node types
resource "aws_route53_record" "private_common" {
  name = var.aws_env != "prod" ? "*.${var.org_name}-net.${var.org_name}.${var.aws_env}" : "*.${var.org_name}-net.${var.org_name}"
  type = "A"
  zone_id = aws_route53_zone.aais_private_zones.zone_id
  alias {
    evaluate_target_health = true
    name = data.aws_alb.blk_nlb.dns_name
    zone_id = data.aws_alb.blk_nlb.zone_id
  }
}


