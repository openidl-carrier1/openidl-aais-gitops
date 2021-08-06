#creating private hosted zones for internal vpc dns resolution
resource "aws_route53_zone" "aais_private_zones" {
  name = var.internal_domain
  comment ="Private hosted zones for dns resolution"
  vpc {
    vpc_id = module.aais_app_vpc.vpc_id
  }
  vpc {
    vpc_id = module.aais_blk_vpc.vpc_id
  }
  tags = merge(
    local.tags,
    {
      "Name" = "${local.std_name}-var.internal_domain"
      "Cluster_type" = "both"
    },)
}
#setting up private dns entries for nlb
resource "aws_route53_record" "this" {
  for_each = toset(var.internal_subdomain)
  zone_id = aws_route53_zone.aais_private_zones.zone_id
  name = "${var.aws_env}-${each.key}"
  type = "A"
  alias {
    name = module.blk_eks_nlb.lb_dns_name
    zone_id = module.blk_eks_nlb.lb_zone_id
    evaluate_target_health = true
  }
}
#authorizing and sharing local private internal hosted zones (private dns) to other aws accounts
resource "aws_route53_vpc_association_authorization" "r53_vpc_authorization" {
  for_each = {for k,v in var.internal_dns_other_account_vpc_to_authorize: k=>v}
    zone_id = aws_route53_zone.aais_private_zones.zone_id
    vpc_id = each.value.vpc_id
    vpc_region = each.value.vpc_region
}
resource "aws_route53_zone_association" "r53_app_vpc_association" {
  for_each = toset(var.other_acc_zone_ids)
    zone_id = each.key
    vpc_id = module.aais_app_vpc.vpc_id
    vpc_region = var.aws_region
}
resource "aws_route53_zone_association" "r53_blk_vpc_association" {
  for_each = toset(var.other_acc_zone_ids)
    zone_id = each.key
    vpc_id = module.aais_blk_vpc.vpc_id
    vpc_region = var.aws_region
}




