#AMI used with bastion host, this identifies the filtered ami from the region
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name = "name"
    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }
  filter {
    name = "owner-alias"
    values = [
      "amazon",
    ]
  }
}
#extracting zone info if the domain is already registered in aws
data "aws_route53_zone" "data_zones" {
  count = (lookup(var.domain_info, "registered") == "yes" && lookup(var.domain_info, "domain_registrar") == "aws") ? 1 : 0
  name  = lookup(var.domain_info, "domain_name")
}
#reading identifying iam identity
data "aws_caller_identity" "current" {
}
#reading application cluster info
data "aws_eks_cluster" "app_eks_cluster" {
  name = module.app_eks_cluster.cluster_id
}
data "aws_eks_cluster_auth" "app_eks_cluster_auth" {
  depends_on = [data.aws_eks_cluster.app_eks_cluster]
  name       = module.app_eks_cluster.cluster_id
}
#reading blockchain cluster info
data "aws_eks_cluster" "blk_eks_cluster" {
  name = module.blk_eks_cluster.cluster_id
}
data "aws_eks_cluster_auth" "blk_eks_cluster_auth" {
  depends_on = [data.aws_eks_cluster.blk_eks_cluster]
  name       = module.blk_eks_cluster.cluster_id
}
#reading availability zones
data "aws_availability_zones" "app_vpc_azs" {
  state = "available"
}
#reading application cluster public subnets
data "aws_subnet_ids" "app_vpc_public_subnets" {
  depends_on = [module.aais_app_vpc]
  vpc_id = module.aais_app_vpc.vpc_id
  filter {
    name = "cidr"
    values = var.app_public_subnets
  }
}
#reading application cluster private subnets
data "aws_subnet_ids" "app_vpc_private_subnets" {
  depends_on = [module.aais_app_vpc]
  vpc_id = module.aais_app_vpc.vpc_id
  filter {
    name = "cidr"
    values = var.app_private_subnets
  }
}
#reading blockchain cluster public subnets
data "aws_subnet_ids" "blk_vpc_public_subnets" {
  depends_on = [module.aais_blk_vpc]
  vpc_id = module.aais_blk_vpc.vpc_id
  filter {
    name = "cidr"
    values = var.blk_public_subnets
  }
}
#reading blockchain cluster private subnets
data "aws_subnet_ids" "blk_vpc_private_subnets" {
  depends_on = [module.aais_blk_vpc]
  vpc_id = module.aais_blk_vpc.vpc_id
  filter {
    name = "cidr"
    values = var.blk_private_subnets
  }
}