#Creating an application cluster VPC in the specific region of the aws account
/*
module "aais_vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  name            = var.cluster_type == "app_cluster" ? "${local.std_name}-vpc" : "${local.std_name}-vpc"
  cidr            = var.vpc_cidr
  azs             = var.availability_zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway     = true
  single_nat_gateway     = var.aws_env == "prod" ? false : true #set to 1 for dev.
  one_nat_gateway_per_az = true
  enable_dns_hostnames   = true
  enable_dns_support     = true
  enable_dhcp_options    = true
  enable_ipv6            = false

  manage_default_network_acl    = false
  default_security_group_name   = var.cluster_type
  manage_default_security_group = true
  manage_default_route_table    = true
  public_dedicated_network_acl  = true
  private_dedicated_network_acl = true

  #default_network_acl_ingress    = var.default_nacl_rules["inbound"]
  #default_network_acl_egress     = var.default_nacl_rules["outbound"]
  public_inbound_acl_rules       = var.public_nacl_rules["inbound"]
  public_outbound_acl_rules      = var.public_nacl_rules["outbound"]
  private_inbound_acl_rules      = var.private_nacl_rules["inbound"]
  private_outbound_acl_rules     = var.private_nacl_rules["outbound"]
  default_security_group_egress  = var.default_sg_rules["egress"]
  default_security_group_ingress = var.default_sg_rules["ingress"]

  default_route_table_tags             = { DefaultRouteTable = true }
  enable_flow_log                      = false
  create_flow_log_cloudwatch_log_group = false
  create_flow_log_cloudwatch_iam_role  = false
  flow_log_max_aggregation_interval    = 60
  tags                                 = merge(local.tags,{"name" = "${local.std_name}-vpc"},)
  vpc_tags                             = merge(local.tags,{"name" = "${local.std_name}-vpc"},)
  public_subnet_tags = merge(local.tags,{
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
    "name"                                        = "${local.std_name}-public_subnets"
  })

  private_subnet_tags = merge(local.tags,{
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
    "name"                                        = "${local.std_name}-private_subnets"
  })
}

#creating transit gateway in application cluster.
module "transit-gateway" {
  depends_on = [module.aais_vpc]
  count = var.cluster_type == "app_cluster" ? 1 : 0
  source = "./transit-gateway"
  create_tgw = true
  share_tgw = var.other_aws_account ? true : false
  name = "${local.std_name}-central-tgw"
  amazon_side_asn = 64532
  description = "The core tgw in the environment to which all VPCs connect"
  enable_auto_accept_shared_attachments = true
  enable_vpn_ecmp_support = true
  vpc_attachments = {
    aais_vpc = {
      vpc_id = module.aais_vpc.vpc_id
      vpc_route_table_ids = module.aais_vpc.private_route_table_ids
      tgw_destination_cidr = var.tgw_destination_cidr
      subnet_ids = module.aais_vpc.private_subnets
      dns_support = true
      transit_gateway_default_route_table_association = true
      transit_gateway_default_route_table_propagation = true
      tgw_routes = var.tgw_routes
    }
  }
  ram_allow_external_principals = true
  ram_principals = var.aws_secondary_account_number
  tags =  merge(local.tags,{
    "name" = "${local.std_name}-central-tgw"
  })
  tgw_default_route_table_tags = merge(local.tags,{
    "name" = "${local.std_name}-central-tgw"
  })
  tgw_route_table_tags = merge(local.tags,{
    "name" = "${local.std_name}-central-tgw"
  })
  tgw_tags = merge(local.tags,{
    "name" = "${local.std_name}-central-tgw"
  })
  tgw_vpc_attachment_tags = merge(local.tags,{
    "name" = "${local.std_name}-central-tgw"
  })
}

#Using existing transit gateway created in app_cluster with blockchain cluster
module "transit-gateway-peer" {
  depends_on = [module.aais_vpc]
  count = var.cluster_type == "blockchain_cluster" ? 1 : 0
  source = "./transit-gateway"
  create_tgw = false
  share_tgw = var.other_aws_account ? true : false
  name = "${local.std_name}-peer-tgw"
  amazon_side_asn = 64532
  description = "The tgw to which VPC has to be attached"
  enable_auto_accept_shared_attachments = true
  enable_vpn_ecmp_support = true
  vpc_attachments = {
    aais_vpc = {
      vpc_id = module.aais_vpc.vpc_id
      tgw_id = var.transit_gateway_id
      vpc_route_table_ids = module.aais_vpc.private_route_table_ids
      tgw_destination_cidr = var.tgw_destination_cidr
      transit_gateway_route_table_id = var.transit_gateway_route_table_id
      subnet_ids = module.aais_vpc.private_subnets
      dns_support = true
      transit_gateway_default_route_table_association = true
      transit_gateway_default_route_table_propagation = true
      tgw_routes = var.tgw_routes
    }
  }
  ram_resource_share_arn = var.tgw_ram_resource_share_id
  ram_allow_external_principals = true
  ram_principals = [var.aws_core_account_number]
  tags = merge(local.tags,{
    "name" = "${local.std_name}-peer-tgw"
  })
  tgw_default_route_table_tags = merge(local.tags,{
    "name" = "${local.std_name}-peer-tgw"
  })
  tgw_route_table_tags = merge(local.tags,{
    "name" = "${local.std_name}-peer-tgw"
  })
  tgw_tags = lmerge(local.tags,{
    "name" = "${local.std_name}-peer-tgw"
  })
  tgw_vpc_attachment_tags = merge(local.tags,{
    "name" = "${local.std_name}-peer-tgw"
  })
}
*/

