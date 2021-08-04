#control plane security group for application cluster (eks)
module "app-eks-control-plane-sg" {
  #for_each = {"app-eks-sg" = "aais_app_vpc", "blk-eks-sg" = "aais_blk_vpc"}
  source              = "terraform-aws-modules/security-group/aws"
  name                = "${local.std_name}-app-eks-ctrl-plane-sg"
  vpc_id              = module.aais_app_vpc.vpc_id
  egress_rules        = ["all-all"]
  number_of_computed_ingress_with_source_security_group_id= 4
  computed_ingress_with_source_security_group_id = [
    {
      from_port                = 1024
      to_port                  = 65535
      protocol                 = "tcp"
      description              = "Inbound from bastion sg to eks control plane sg-1024-65535"
      source_security_group_id = module.app_bastion_sg.security_group_id
    },
    {
      from_port                = 433
      to_port                  = 433
      protocol                 = "tcp"
      description              = "Inbound from bastion sg to eks control plane sg-443"
      source_security_group_id = module.app_bastion_sg.security_group_id
    },
    {
      from_port                = 1024
      to_port                  = 65535
      protocol                 = "tcp"
      description              = "Inbound from nodegroup sg to eks control plane sg-1024-65535"
      source_security_group_id = module.app-eks-worker-node-group-sg.security_group_id
    },
    {
      from_port                = 433
      to_port                  = 433
      protocol                 = "tcp"
      description              = "Inbound from nodegroup sg to eks control plane sg-443"
      source_security_group_id = module.app-eks-worker-node-group-sg.security_group_id
    }]
    tags = merge(local.tags, {
      Name = "${local.std_name}-app-eks-ctrl-plane-sg",
      "Cluster_type" = "application"})
}
#control plane security group for blockchain cluster (eks)
module "blk-eks-control-plane-sg" {
  #for_each = {"app-eks-sg" = "aais_app_vpc", "blk-eks-sg" = "aais_blk_vpc"}
  source              = "terraform-aws-modules/security-group/aws"
  name                = "${local.std_name}-blk-eks-ctrl-plane-sg"
  vpc_id              = module.aais_blk_vpc.vpc_id
  egress_rules        = ["all-all"]
  number_of_computed_ingress_with_source_security_group_id= 4
  computed_ingress_with_source_security_group_id = [
    {
      from_port                = 1024
      to_port                  = 65535
      protocol                 = "tcp"
      description              = "Inbound from bastion sg to eks control plane sg-1024-65535"
      source_security_group_id = module.blk_bastion_sg.security_group_id
    },
    {
      from_port                = 433
      to_port                  = 433
      protocol                 = "tcp"
      description              = "Inbound from bastion sg to eks control plane sg-443"
      source_security_group_id = module.blk_bastion_sg.security_group_id
    },
  {
      from_port                = 1024
      to_port                  = 65535
      protocol                 = "tcp"
      description              = "Inbound from nodegroup sg to eks control plane sg-1024-65535"
      source_security_group_id = module.blk-eks-worker-node-group-sg.security_group_id
    },
    {
      from_port                = 433
      to_port                  = 433
      protocol                 = "tcp"
      description              = "Inbound from nodegroup sg to eks control plane sg-443"
      source_security_group_id = module.blk-eks-worker-node-group-sg.security_group_id
    }]
    tags = merge(local.tags, {
      Name = "${local.std_name}-blk-eks-ctrl-plane-sg",
      "Cluster_type" = "blockchain"})
}
#workers security group for application cluster (eks)
module "app-eks-worker-node-group-sg" {
  source = "terraform-aws-modules/security-group/aws"
  name = "${local.std_name}-app-eks-worker-node-group-sg"
  vpc_id = module.aais_app_vpc.vpc_id
  ingress_cidr_blocks = [var.app_vpc_cidr]
  ingress_rules       = ["ssh-tcp", "https-443-tcp", "http-80-tcp"]
  number_of_computed_ingress_with_source_security_group_id= 6
  egress_rules = ["all-all"]
  computed_ingress_with_source_security_group_id = [
    {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      description = "Inbound from bastion hosts sg to node group sg-22"
      source_security_group_id = module.app_bastion_sg.security_group_id
    },
    {
      from_port = 10250
      to_port = 10250
      protocol = "tcp"
      description = "Inbound from control plane sg to node group sg-10250"
      source_security_group_id = module.app-eks-control-plane-sg.security_group_id
    },
    {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      description = "Inbound from control plane sg to node group sg-443"
      source_security_group_id = module.app-eks-control-plane-sg.security_group_id
    },
    {
      from_port = 1024
      to_port = 65535
      protocol = "tcp"
      description = "Inbound from control plane sg to node group sg-1024-65535"
      source_security_group_id = module.app-eks-control-plane-sg.security_group_id
    },
    {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      description = "Inbound from node group sg to node group sg-443"
      source_security_group_id = module.app-eks-worker-node-group-sg.security_group_id
    },
    {
      from_port = 1024
      to_port = 65535
      protocol = "tcp"
      description = "Inbound from node group sg to node group sg-1024-65535"
      source_security_group_id = module.app-eks-worker-node-group-sg.security_group_id
    }]
  tags = merge(local.tags, {
    Name = "${local.std_name}-app-eks-worker-node-group-sg"
    "kubernetes.io/cluster/${local.app_cluster_name}" = "owned"
    "Cluster_type" = "application"})
}
#workers security group for blockchain cluster (eks)
module "blk-eks-worker-node-group-sg" {
  source = "terraform-aws-modules/security-group/aws"
  name = "${local.std_name}-blk-eks-worker-node-group-sg"
  vpc_id = module.aais_blk_vpc.vpc_id
  ingress_cidr_blocks = [var.blk_vpc_cidr]
  ingress_rules       = ["ssh-tcp", "https-443-tcp", "http-80-tcp"]
  number_of_computed_ingress_with_source_security_group_id= 6
  egress_rules = ["all-all"]
  computed_ingress_with_source_security_group_id = [
    {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      description = "Inbound from bastion hosts sg to node group sg-22"
      source_security_group_id = module.blk_bastion_sg.security_group_id
    },
    {
      from_port = 10250
      to_port = 10250
      protocol = "tcp"
      description = "Inbound from control plane sg to node group sg-10250"
      source_security_group_id = module.blk-eks-control-plane-sg.security_group_id
    },
    {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      description = "Inbound from control plane sg to node group sg-443"
      source_security_group_id = module.blk-eks-control-plane-sg.security_group_id
    },
    {
      from_port = 1024
      to_port = 65535
      protocol = "tcp"
      description = "Inbound from control plane sg to node group sg-1024-65535"
      source_security_group_id = module.blk-eks-control-plane-sg.security_group_id
    },
    {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      description = "Inbound from node group sg to node group sg-443"
      source_security_group_id = module.blk-eks-worker-node-group-sg.security_group_id
    },
    {
      from_port = 1024
      to_port = 65535
      protocol = "tcp"
      description = "Inbound from node group sg to node group sg-1024-65535"
      source_security_group_id = module.blk-eks-worker-node-group-sg.security_group_id
    }]
  tags = merge(local.tags, {
    Name = "${local.std_name}-blk-eks-worker-node-group-sg"
    "kubernetes.io/cluster/${local.blk_cluster_name}" = "owned"
    "Cluster_type" = "application"})
}

