# public network load balancer in application cluster - related security group
module "app_eks_nlb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"
  name        = "${local.std_name}-app-eks-nlb-sg"
  description = "Security group for app cluster EKS NLB"
  vpc_id      = module.aais_app_vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp"] # port 80 will be redirected to 443 at ALB level
  egress_rules        = ["all-all"]
  tags = merge(
    local.tags,
    {
      "Cluster_type" = "application"
    },)
}
# public network load balancer in application cluster and its certificate
module "app_eks_nlb_acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.0"
  domain_name = lookup(var.domain_info, "domain_name") # trimsuffix(data.aws_route53_zone.this.name, ".") # Terraform >= 0.12.17
  # may need to setup condition either to use data resource or module route53 zone to pull based on domain registrar
  #zone_id      = aws_route53_zone.zones[0].id || data.aws_route53_zone.this.id
  zone_id     = (lookup(var.domain_info, "registered") == "yes" && lookup(var.domain_info, "domain_registrar") == "aws") ? data.aws_route53_zone.data_zones[0].id : aws_route53_zone.zones[0].id
  validation_method = "EMAIL" #alternate DNS validation
    tags = merge(
    local.tags,
    {
      "Name" = "${var.domain_info.domain_name}"
      "Cluster_type" = "application"
    },)
  subject_alternative_names = [
    "*.${var.domain_info.domain_name}",
  ]
}
# public network load balancer in application cluster
module "app_eks_nlb" {
  depends_on = [data.aws_subnet_ids.app_vpc_public_subnets, module.aais_app_vpc]
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"
  name = "${local.std_name}-app-eks-nlb"
  create_lb = true
  load_balancer_type = "network"
  enable_cross_zone_load_balancing = true
  internal = false
  ip_address_type = "ipv4"
  vpc_id = module.aais_app_vpc.vpc_id
  subnets = module.aais_app_vpc.public_subnets
 #security_groups = [module.app_eks_nlb_sg.security_group_id]
  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "TCP"
      action_type = "forward"
    }
  ]
  target_groups = [
    {
      name_prefix      = "tgapp-"
      backend_protocol = "TCP"
      backend_port     = 80
      target_type      = "instance"
      preserve_client_ip = true
      tags = merge(local.tags, { tcp_udp = true },)
      health_check = {
        enabled             = true
        interval            = 30
        port                = "80"
        protocol            = "TCP"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        #timeout             = 6
      }
    }
  ]
  tags = merge(
    local.tags,
    {
      "Cluster_type" = "application"
    },)
  lb_tags = merge(
    local.tags,
    {
      "Cluster_type" = "application"
    },)
  idle_timeout = 180
  target_group_tags = merge(
    local.tags,
    {
      "Name" = "tgapp-"
      "Cluster_type" = "application"
    },)
}
# private network load balancer in blockchain cluster - related security group
module "blk_eks_nlb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"
  name        = "${local.std_name}-blk-eks-nlb-sg"
  description = "Security group for blk cluster EKS NLB"
  vpc_id      = module.aais_blk_vpc.vpc_id
  ingress_with_cidr_blocks = var.blk_eks_nlb_sg_ingress
  egress_with_cidr_blocks = var.blk_eks_nlb_sg_egress
  tags = merge(
    local.tags,
    {
      "Cluster_type" = "blockchain"
    },)
}
module "blk_eks_nlb" {
  depends_on = [data.aws_subnet_ids.blk_vpc_private_subnets, module.aais_blk_vpc]
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"
  name = "${local.std_name}-blk-eks-nlb"
  create_lb = true
  load_balancer_type = "network"
  enable_cross_zone_load_balancing = true
  internal = true
  ip_address_type = "ipv4"
  vpc_id = module.aais_blk_vpc.vpc_id
  subnets = module.aais_blk_vpc.private_subnets
  #security_groups = [module.blk_eks_alb_sg.security_group_id]
  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "TCP"
      action_type = "forward"
    }
  ]
  target_groups = [
    {
      name_prefix      = "tgblk-"
      backend_protocol = "TCP"
      backend_port     = 80
      target_type      = "instance"
      preserve_client_ip = true
      tags = merge(local.tags, { tcp_udp = true },)
      health_check = {
        enabled             = true
        interval            = 30
        port                = "80"
        protocol            = "TCP"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        #timeout             = 6
      }
    }
  ]
  tags = merge(
    local.tags,
    {
      "Cluster_type" = "blockchain"
    },)
  lb_tags = merge(
    local.tags,
    {
      "Cluster_type" = "blockchain"
    },)
  idle_timeout = 180
  target_group_tags = merge(
    local.tags,
    {
      "Name" = "tgblk"
      "Cluster_type" = "blockchain"
    },)
}

