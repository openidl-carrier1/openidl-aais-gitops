/*
module "app_eks_sg" {
  source              = "terraform-aws-modules/security-group/aws"
  name                = var.app_eks_sg
  description         = "Security group for app-service with custom ports open within VPC  open"
  vpc_id              = module.aais_vpc.vpc_id
  ingress_cidr_blocks = [var.vpc_cidr]
  ingress_rules       = ["ssh-tcp", "https-443-tcp", "https-8443-tcp"]
  egress_rules        = ["all-all"]
  computed_ingress_with_source_security_group_id = [
    {
      from_port                = 1024
      to_port                  = 65535
      protocol                 = "tcp"
      description              = "Allow EKS Control Plane"
      source_security_group_id = module.bastion_sg.security_group_id
    },
    {
      from_port                = 433
      to_port                  = 433
      protocol                 = "tcp"
      description              = "Allow EKS Control Plane"
      source_security_group_id = module.bastion_sg.security_group_id
    }
  ]
  tags = local.tags
}
module "worker_group_mgmt_one" {
  source              = "terraform-aws-modules/security-group/aws"
  name                = var.eks_worker_group_sg_mgmt_one
  vpc_id              = module.aais_vpc.vpc_id
  ingress_cidr_blocks = [var.vpc_cidr]
  ingress_rules       = ["ssh-tcp", "https-443-tcp", "https-8443-tcp"]
  egress_rules        = ["all-all"]
}
module "worker_group_mgmt_two" {
  source              = "terraform-aws-modules/security-group/aws"
  name                = var.eks_worker_group_sg_mgmt_two
  vpc_id              = module.aais_vpc.vpc_id
  ingress_cidr_blocks = [var.vpc_cidr]
  ingress_rules       = ["ssh-tcp", "https-443-tcp", "https-8443-tcp"]
  egress_rules        = ["all-all"]
}
module "all_worker_mgmt" {
  source              = "terraform-aws-modules/security-group/aws"
  name                = "all_worker_management"
  vpc_id              = module.aais_vpc.vpc_id
  ingress_cidr_blocks = [var.vpc_cidr]
  ingress_rules       = ["ssh-tcp", "https-443-tcp", "https-8443-tcp"]
  egress_rules        = ["all-all"]
}

*/
