#creating private hosted zones for internal vpc dns resolution
resource "aws_route53_zone" "aais_private_zones" {
  name    = var.internal_domain
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
      "Name"         = "${local.std_name}-var.internal_domain"
      "Cluster_type" = "both"
  }, )
}
#setting up private dns entries for nlb
resource "aws_route53_record" "aais_private_records" {
  count = length(var.internal_subdomain)
  #for_each = toset(var.internal_subdomain)
  zone_id = aws_route53_zone.aais_private_zones.zone_id
  name    = "${var.aws_env}-${var.internal_subdomain[count.index]}"
  type    = "A"
  alias {
    name                   = module.blk_eks_nlb.lb_dns_name
    zone_id                = module.blk_eks_nlb.lb_zone_id
    evaluate_target_health = true
  }
}





