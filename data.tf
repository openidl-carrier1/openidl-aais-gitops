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
data "aws_route53_zone" "data_zones" {
  count = var.cluster_type == "app_cluster" && (lookup(var.domain_info, "registered") == "yes" && lookup(var.domain_info, "domain_registrar") == "aws") ? 1 : 0
  name  = lookup(var.domain_info, "domain_name")
}
resource "random_string" "suffix" {
  length  = 5
  special = false
}
resource "random_pet" "this" {
  length = 2
}
resource "random_id" "instance_name_count" {
  byte_length = 2
}
/*
data "aws_caller_identity" "current" {
}
data "aws_eks_cluster" "cluster" {
  name = module.app_eks.cluster_id
}
data "aws_eks_cluster_auth" "cluster" {
  depends_on = [data.aws_eks_cluster.cluster]
  name       = module.app_eks.cluster_id
}
*/
#check if a filter is required to specific VPC if so enable VPC_ID
data "aws_availability_zones" "available" {
  #vpc_id = module.aais_vpc.vpc_id
  state = "available"
}
data "aws_subnet_ids" "aais_vpc_public_subnets" {
  depends_on = [module.aais_vpc]
  vpc_id = module.aais_vpc.vpc_id
  filter {
    name = "cidr"
    values = var.public_subnets
  }
}
data "aws_subnet_ids" "aais_vpc_private_subnets" {
  depends_on = [module.aais_vpc]
  vpc_id = module.aais_vpc.vpc_id
  filter {
    name = "cidr"
    values = var.public_subnets
  }
}