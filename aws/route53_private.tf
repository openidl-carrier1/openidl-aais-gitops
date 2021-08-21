#creating private hosted zones for internal vpc dns resolution
resource "aws_route53_zone" "aais_private_zones" {
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
#setting up private dns entries for app bastion host nlb
resource "aws_route53_record" "private_record_app_nlb_bastion" {
  count = var.bastion_host_nlb_external ? 0 : 1
  zone_id = aws_route53_zone.aais_private_zones.zone_id
  name = "${local.std_name}-app-bastion"
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
  name = "${local.std_name}-blk-bastion"
  type    = "A"
  alias {
    name                   = module.blk_bastion_nlb.lb_dns_name
    zone_id                = module.blk_bastion_nlb.lb_zone_id
    evaluate_target_health = true
  }
}



