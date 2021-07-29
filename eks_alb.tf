module "eks_alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "${local.stdname}-eks-alb-sg"
  description = "Security group for EKS ALB"
  vpc_id      = module.aais_vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"] #change to vpc cidr when moved to internal elb
  ingress_rules       = ["https-443-tcp", "http-80-tcp"] #included port 80 for testing
  egress_rules        = ["all-all"]
}
/*
module "eks_alb_acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.0"
  domain_name = lookup(var.domain_info, "domain_name") # trimsuffix(data.aws_route53_zone.this.name, ".") # Terraform >= 0.12.17
  #zone_id     = data.aws_route53_zone.this.id
  zone_id     = aws_route53_zone.zones[0].id
  validation_method = "EMAIL" #alternate DNS validation
  tags = local.tags
  subject_alternative_names = [
    "*.${var.domain_info.domain_name}",
  ]
}*/
module "eks_alb" {
  depends_on = [data.aws_subnet_ids.aais_vpc_private_subnets, module.aais_vpc]
  #depends_on = [module.aais_vpc, module.app_eks.cluster_id]
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"
  name = "${local.stdname}-eks-alb"
  create_lb = true
  load_balancer_type = "application"
  enable_cross_zone_load_balancing = true
  internal = false #changed to work with Route53
  ip_address_type = "ipv4"
  vpc_id = module.aais_vpc.vpc_id
  #changed from private to public for testing
  subnets = module.aais_vpc.public_subnets
  security_groups = [module.eks_alb_sg.security_group_id]
 /*
  http_tcp_listeners = [
    {
      port = 80
      protocol ="HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
        }
      }]
  https_listeners = [
    {
      port        = 443
      protocol    = "HTTPS"
      action_type = "forward"
      certificate_arn    = module.eks_alb_acm.acm_certificate_arn #create certificate/otherwise use data resource to fetch
    }
  ]*/
  http_tcp_listeners = [
    {
      port = 80
      protocol = "HTTP"
      action_type = "forward"
    }]
   target_groups = [
    {
      name_prefix      = var.cluster_type == "app_cluster" ? "eks-tg" : "blk-tg"
      backend_protocol = "HTTP"
      backend_port     = 80 #change to 443
      target_type      = "instance"
      vpc_id           = "${module.aais_vpc.vpc_id}"
      tags = local.tags
      #added for testing
      #target_group_arn = aws_instance.private_ec2.arn
      health_check = {
        enabled             = true
        interval            = 30
        protocol            = "HTTP" #change to HTTPS
        port                = "80" #change to 443
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        path                = "/"
      }
    }
  ]
  tags = local.tags
  lb_tags = local.tags
  idle_timeout = 180
  target_group_tags = local.tags
}
