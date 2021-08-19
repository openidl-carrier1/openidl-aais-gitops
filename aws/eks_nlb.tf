# public network load balancer in application cluster for EKS
module "app_eks_nlb" {
  depends_on                       = [data.aws_subnet_ids.app_vpc_public_subnets, module.aais_app_vpc]
  source                           = "terraform-aws-modules/alb/aws"
  version                          = "~> 6.0"
  name                             = "${local.std_name}-app-eks-nlb"
  create_lb                        = true
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = true
  internal                         = false
  ip_address_type                  = "ipv4"
  vpc_id                           = module.aais_app_vpc.vpc_id
  subnets                          = module.aais_app_vpc.public_subnets
  http_tcp_listeners = [
    {
      port        = 443
      protocol    = "TCP"
      action_type = "forward"
    }
  ]
  target_groups = [
    {
      name_prefix        = "apnlb-"
      backend_protocol   = "TCP"
      backend_port       = 443
      target_type        = "instance"
      preserve_client_ip = true
      tags               = merge(local.tags, { tcp_udp = true }, )
      health_check = {
        enabled             = true
        interval            = 30
        port                = "443"
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
  }, )
  lb_tags = merge(
    local.tags,
    {
      "Cluster_type" = "application"
  }, )
  idle_timeout = 180
  target_group_tags = merge(
    local.tags,
    {
      "Name"         = "app-nlb"
      "Cluster_type" = "application"
  }, )
}
# public network load balancer in blockchain cluster for EKS
module "blk_eks_nlb_public" {
  depends_on                       = [data.aws_subnet_ids.blk_vpc_private_subnets, module.aais_blk_vpc]
  source                           = "terraform-aws-modules/alb/aws"
  version                          = "~> 6.0"
  name                             = "${local.std_name}-blk-eks-nlb-public"
  create_lb                        = true
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = true
  internal                         = false
  ip_address_type                  = "ipv4"
  vpc_id                           = module.aais_blk_vpc.vpc_id
  subnets                          = module.aais_blk_vpc.private_subnets
  http_tcp_listeners = [
    {
      port        = 443
      protocol    = "TCP"
      action_type = "forward"
    }
  ]
  target_groups = [
    {
      name_prefix        = "bnlb1-"
      backend_protocol   = "TCP"
      backend_port       = 443
      target_type        = "instance"
      preserve_client_ip = true
      tags               = merge(local.tags, { tcp_udp = true }, )
      health_check = {
        enabled             = true
        interval            = 30
        port                = "443"
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
  }, )
  lb_tags = merge(
    local.tags,
    {
      "Cluster_type" = "blockchain"
  }, )
  idle_timeout = 180
  target_group_tags = merge(
    local.tags,
    {
      "Name"         = "blk-nlb-public"
      "Cluster_type" = "blockchain"
  }, )
}
# private network load balancer in blockchain cluster for EKS
module "blk_eks_nlb_private" {
  depends_on                       = [data.aws_subnet_ids.blk_vpc_private_subnets, module.aais_blk_vpc]
  source                           = "terraform-aws-modules/alb/aws"
  version                          = "~> 6.0"
  name                             = "${local.std_name}-blk-eks-nlb-private"
  create_lb                        = true
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = true
  internal                         = true
  ip_address_type                  = "ipv4"
  vpc_id                           = module.aais_blk_vpc.vpc_id
  subnets                          = module.aais_blk_vpc.private_subnets
  http_tcp_listeners = [
    {
      port        = 443
      protocol    = "TCP"
      action_type = "forward"
    }
  ]
  target_groups = [
    {
      name_prefix        = "bnlb2-"
      backend_protocol   = "TCP"
      backend_port       = 443
      target_type        = "instance"
      preserve_client_ip = true
      tags               = merge(local.tags, { tcp_udp = true }, )
      health_check = {
        enabled             = true
        interval            = 30
        port                = "443"
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
  }, )
  lb_tags = merge(
    local.tags,
    {
      "Cluster_type" = "blockchain"
  }, )
  idle_timeout = 180
  target_group_tags = merge(
    local.tags,
    {
      "Name"         = "blk-nlb-private"
      "Cluster_type" = "blockchain"
  }, )
}

