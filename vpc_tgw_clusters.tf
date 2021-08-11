#Creating an application cluster VPC
module "aais_app_vpc" {
  create_vpc      = true
  source          = "terraform-aws-modules/vpc/aws"
  name            = "${local.std_name}-app-vpc"
  cidr            = var.app_vpc_cidr
  azs             = var.app_availability_zones
  private_subnets = var.app_private_subnets
  public_subnets  = var.app_public_subnets

  enable_nat_gateway     = true
  single_nat_gateway     = var.aws_env == "prod" ? false : true #set to 1 for dev
  one_nat_gateway_per_az = true
  enable_dns_hostnames   = true
  enable_dns_support     = true
  enable_dhcp_options    = true
  enable_ipv6            = false

  #manage_default_network_acl    = false
  default_security_group_name   = "${local.std_name}-app-vpc-def-sg"
  manage_default_security_group = true
  manage_default_route_table    = true
  public_dedicated_network_acl  = true
  private_dedicated_network_acl = true

  #default_network_acl_ingress    = var.default_nacl_rules["inbound"]
  #default_network_acl_egress     = var.default_nacl_rules["outbound"]
  public_inbound_acl_rules       = var.app_public_nacl_rules["inbound"]
  public_outbound_acl_rules      = var.app_public_nacl_rules["outbound"]
  private_inbound_acl_rules      = var.app_private_nacl_rules["inbound"]
  private_outbound_acl_rules     = var.app_private_nacl_rules["outbound"]
  default_security_group_egress  = var.default_sg_rules["egress"]
  default_security_group_ingress = var.default_sg_rules["ingress"]

  default_route_table_tags             = { DefaultRouteTable = true }
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60
  tags                                 = merge(local.tags, {"Cluster_type" = "application"})
  vpc_tags                             = merge(local.tags, {"Cluster_type" = "application"})
  public_subnet_tags = merge(local.tags,{
    "kubernetes.io/cluster/${local.app_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
    "Cluster_type" = "application"
  })

  private_subnet_tags = merge(local.tags,{
    "kubernetes.io/cluster/${local.app_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
    "Cluster_type" = "application"
  })
}
#Creating an blockchain cluster VPC
module "aais_blk_vpc" {
  create_vpc      = true
  source          = "terraform-aws-modules/vpc/aws"
  name            = "${local.std_name}-blk-vpc"
  cidr            = var.blk_vpc_cidr
  azs             = var.blk_availability_zones
  private_subnets = var.blk_private_subnets
  public_subnets  = var.blk_public_subnets

  enable_nat_gateway     = true
  single_nat_gateway     = var.aws_env == "prod" ? false : true #set to 1 for dev
  one_nat_gateway_per_az = true
  enable_dns_hostnames   = true
  enable_dns_support     = true
  enable_dhcp_options    = true
  enable_ipv6            = false

  manage_default_network_acl    = false
  default_security_group_name   = "${local.std_name}-blk-vpc-def-sg"
  manage_default_security_group = true
  manage_default_route_table    = true
  public_dedicated_network_acl  = true
  private_dedicated_network_acl = true

  #default_network_acl_ingress    = var.default_nacl_rules["inbound"]
  #default_network_acl_egress     = var.default_nacl_rules["outbound"]
  public_inbound_acl_rules       = var.blk_public_nacl_rules["inbound"]
  public_outbound_acl_rules      = var.blk_public_nacl_rules["outbound"]
  private_inbound_acl_rules      = var.blk_private_nacl_rules["inbound"]
  private_outbound_acl_rules     = var.blk_private_nacl_rules["outbound"]
  default_security_group_egress  = var.default_sg_rules["egress"]
  default_security_group_ingress = var.default_sg_rules["ingress"]

  default_route_table_tags             = { DefaultRouteTable = true }
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60
  tags                                 = merge(local.tags, {"Cluster_type" = "blockchain"})
  vpc_tags                             = merge(local.tags, {"Cluster_type" = "blockchain"})
  public_subnet_tags = merge(local.tags,{
    "kubernetes.io/cluster/${local.blk_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
    "Cluster_type" = "blockchain"
  })

  private_subnet_tags = merge(local.tags,{
    "kubernetes.io/cluster/${local.blk_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
    "Cluster_type" = "blockchain"
  })
}
#creating transit gateway on aais environment or carrier on another aws region
module "transit_gateway" {
  count = var.aais || (!var.aais && var.other_aws_account && var.other_aws_region) ? 1 : 0
  depends_on = [module.aais_app_vpc, module.aais_blk_vpc]
  source = "./transit-gateway"
  create_tgw = var.aais || (!var.aais && var.other_aws_region) ? true : false
  share_tgw = var.aais && var.other_aws_account || !var.aais && var.other_aws_region ? true : false
  name = "${local.std_name}-central-tgw"
  amazon_side_asn = var.tgw_amazon_side_asn
  description = "The core tgw in the environment to which all VPCs connect"
  enable_auto_accept_shared_attachments = true
  enable_vpn_ecmp_support = true
  vpc_attachments = {
    app_vpc = {
      vpc_id = module.aais_app_vpc.vpc_id
      vpc_route_table_ids = module.aais_app_vpc.private_route_table_ids
      tgw_destination_cidr = var.app_tgw_destination_cidr
      subnet_ids = module.aais_app_vpc.private_subnets
      dns_support = true
      transit_gateway_default_route_table_association = true
      transit_gateway_default_route_table_propagation = true
      tgw_routes = var.app_tgw_routes
    },
    blk_vpc = {
      vpc_id = module.aais_blk_vpc.vpc_id
      vpc_route_table_ids = module.aais_blk_vpc.private_route_table_ids
      tgw_destination_cidr = var.blk_tgw_destination_cidr
      subnet_ids = module.aais_blk_vpc.private_subnets
      dns_support = true
      transit_gateway_default_route_table_association = true
      transit_gateway_default_route_table_propagation = true
      tgw_routes = var.blk_tgw_routes
    }
  }
  ram_allow_external_principals = true
  ram_principals = var.aws_secondary_account_number
  tags =  merge(local.tags, { "Cluster_type" = "application"})
  tgw_default_route_table_tags = merge(local.tags, { "Cluster_type" = "application"})
  tgw_route_table_tags = merge(local.tags, { "Cluster_type" = "application"})
  tgw_tags = merge(local.tags, { "Cluster_type" = "application"})
  tgw_vpc_attachment_tags = merge(local.tags, { "Cluster_type" = "application"})
}

#Connects to existing transit gateway on aais environment or another carrier both on another aws account but same region
module "transit_gateway_peer" {
  #(!var.aais && var.other_aws_account && var.other_aws_region)
  count = !var.aais && var.other_aws_account && !var.other_aws_region ? 1 : 0
  depends_on = [module.aais_blk_vpc,module.aais_app_vpc,module.transit_gateway]
  source = "./transit-gateway"
  create_tgw = false
  share_tgw = var.other_aws_account && !var.aais ? true : false
  name = "${local.std_name}-peer-tgw"
  amazon_side_asn = var.tgw_amazon_side_asn
  description = "The tgw to which VPC has to be attached"
  enable_auto_accept_shared_attachments = true
  enable_vpn_ecmp_support = true
  vpc_attachments = {
    blk_vpc = {
      vpc_id = module.aais_blk_vpc.vpc_id
      tgw_id = var.transit_gateway_id
      vpc_route_table_ids = module.aais_blk_vpc.private_route_table_ids
      tgw_destination_cidr = var.blk_tgw_destination_cidr
      transit_gateway_route_table_id = var.transit_gateway_route_table_id
      subnet_ids = module.aais_blk_vpc.private_subnets
      dns_support = true
      transit_gateway_default_route_table_association = true
      transit_gateway_default_route_table_propagation = true
      tgw_routes = var.blk_tgw_routes
    },
    app_vpc = {
      vpc_id = module.aais_app_vpc.vpc_id
      tgw_id = var.transit_gateway_id
      vpc_route_table_ids = module.aais_app_vpc.private_route_table_ids
      tgw_destination_cidr = var.app_tgw_destination_cidr
      transit_gateway_route_table_id = var.transit_gateway_route_table_id
      subnet_ids = module.aais_app_vpc.private_subnets
      dns_support = true
      transit_gateway_default_route_table_association = true
      transit_gateway_default_route_table_propagation = true
      tgw_routes = var.app_tgw_routes
    },
  }
  ram_resource_share_arn = var.tgw_ram_resource_share_id
  ram_allow_external_principals = true
  ram_principals = [var.aws_core_account_number]
  tags = local.tags
  tgw_default_route_table_tags = local.tags
  tgw_route_table_tags = local.tags
  tgw_tags = local.tags
  tgw_vpc_attachment_tags = local.tags
}
