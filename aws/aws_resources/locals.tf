##local variables and their manipulation are here
locals {
  std_name          = "${substr(var.org_name,0,4)}-${var.aws_env}"
  app_cluster_name  = "${local.std_name}-${var.app_cluster_name}"
  blk_cluster_name  = "${local.std_name}-${var.blk_cluster_name}"
  policy_arn_prefix = "arn:aws:iam::aws:policy"
  tags = {
    Application = "openidl"
    Environment = var.aws_env
    Managed_by  = "terraform"
    Node_type   = var.org_name
  }
  bastion_host_userdata = filebase64("resources/bootstrap_scripts/bastion_host.sh")
  worker_nodes_userdata = filebase64("resources/bootstrap_scripts/worker_nodes.sh")
  #cognito custom attributes
  custom_attributes = [
    "role",
    "stateCode",
    "stateName",
    "organizationId"]
  #application cluster (eks) config-map (aws auth) - iam user to map

  app_def_sg_ingress = [{
    cidr_blocks = var.app_vpc_cidr
    description = "Inbound SSH traffic"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
  },
  {
    cidr_blocks = var.app_vpc_cidr
    description = "Inbound SSH traffic"
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
  },
  {
    cidr_blocks = var.app_vpc_cidr
    description = "Inbound SSH traffic"
    from_port   = "8443"
    to_port     = "8443"
    protocol    = "tcp"
  }]
  blk_def_sg_ingress = [{
    cidr_blocks = var.blk_vpc_cidr
    description = "Inbound SSH traffic"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
  },
  {
    cidr_blocks = var.blk_vpc_cidr
    description = "Inbound SSH traffic"
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
  },
  {
    cidr_blocks = var.blk_vpc_cidr
    description = "Inbound SSH traffic"
    from_port   = "8443"
    to_port     = "8443"
    protocol    = "tcp"
  }]
  def_sg_egress = [{
    cidr_blocks = "0.0.0.0/0"
    description = "Outbound SSH traffic"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
  },
  {
    cidr_blocks = "0.0.0.0/0"
    description = "Outbound SSH traffic"
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
  },
  {
    cidr_blocks = "0.0.0.0/0"
    description = "Outbound SSH traffic"
    from_port   = "8443"
    to_port     = "8443"
    protocol    = "tcp"
  }]

  app_tgw_routes = [{destination_cidr_block = var.blk_vpc_cidr}]
  blk_tgw_routes = [{destination_cidr_block = var.app_vpc_cidr}]
  app_tgw_destination_cidr = ["${var.blk_vpc_cidr}"]
  blk_tgw_destination_cidr = ["${var.app_vpc_cidr}"]

  vault_secrets_set_non_prod = {
    url = "http://vault.${var.org_name}.${var.aws_env}.internal.${var.domain_info.sub_domain_name}.${var.domain_info.domain_name}"
    username = "config-${var.org_name}"
    password = random_password.vault_password.result
    orgName = "${var.org_name}"
    vaultPath = "config-${var.org_name}"
    apiVersion = "v1"
  }
  vault_secrets_set_prod = {
    url = "http://vault.${var.org_name}.internal.${var.domain_info.sub_domain_name}.${var.domain_info.domain_name}"
    username = "config-${var.org_name}"
    password = random_password.vault_password.result
    orgName = "${var.org_name}"
    vaultPath = "config-${var.org_name}"
    apiVersion = "v1"
  }
    dns_entries_list_non_prod = {
    "app-bastion.${var.aws_env}.${var.domain_info.sub_domain_name}.${var.domain_info.domain_name}" = module.app_bastion_nlb.lb_dns_name,
    "blk-bastion.${var.aws_env}.${var.domain_info.sub_domain_name}.${var.domain_info.domain_name}"= module.blk_bastion_nlb.lb_dns_name,
    }
    dns_entries_list_prod = {
    "app-bastion.${var.domain_info.sub_domain_name}.${var.domain_info.domain_name}" = module.app_bastion_nlb.lb_dns_name,
    "blk-bastion.${var.domain_info.sub_domain_name}.${var.domain_info.domain_name}" = module.blk_bastion_nlb.lb_dns_name,
    }

}
