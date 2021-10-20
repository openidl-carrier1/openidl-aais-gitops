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
  #application cluster (eks) config-map (aws auth) - iam user to map
  app_cluster_map_users = [{
    userarn = data.terraform_remote_state.base_setup.outputs.baf_automation_user_arn
    username = "admin"
    groups = ["system:masters"]
  }]

  #application cluster (eks) config-map (aws auth) - iam user to map
  blk_cluster_map_users = [{
    userarn = data.terraform_remote_state.base_setup.outputs.baf_automation_user_arn
    username = "admin"
    groups = ["system:masters"]
  }]
  #application cluster (eks) config-map (aws auth) - iam roles to map
  app_cluster_map_roles = [
    {
      rolearn  = data.terraform_remote_state.base_setup.outputs.app_eks_nodegroup_role_arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = [
        "system:masters",
        "system:nodes",
        "system:bootstrappers"]
  },
  {
      rolearn  = data.terraform_remote_state.base_setup.outputs.eks_admin_role_arn
      username = "admin"
      groups = [
        "system:masters",
        "system:nodes",
        "system:bootstrappers"]
  },
  {
      rolearn  = data.terraform_remote_state.base_setup.outputs.git_actions_admin_role_arn
      username = "admin"
      groups = [
        "system:masters",
        "system:nodes",
        "system:bootstrappers"]
  }]
  #blockchain cluster (eks) config-map (aws auth) - iam roles to map
  blk_cluster_map_roles = [
    {
      rolearn  = data.terraform_remote_state.base_setup.outputs.blk_eks_nodegroup_role_arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = [
        "system:masters",
        "system:nodes",
        "system:bootstrappers"]
  },
    {
      rolearn  = data.terraform_remote_state.base_setup.outputs.eks_admin_role_arn
      username = "admin"
      groups = [
        "system:masters",
        "system:nodes",
        "system:bootstrappers"]
  },
  {
      rolearn  = data.terraform_remote_state.base_setup.outputs.git_actions_admin_role_arn
      username = "admin"
      groups = [
        "system:masters",
        "system:nodes",
        "system:bootstrappers"]
  }]
  app_cluster_map_roles_list = [for key in var.app_cluster_map_roles :
    {
      rolearn  = "${key}"
      username = "admin"
      groups   = ["system:masters"]
  }]

  blk_cluster_map_roles_list = [for key in var.blk_cluster_map_roles :
    {
      rolearn  = "${key}"
      username = "admin"
      groups   = ["system:masters"]
  }]

  app_cluster_map_users_list = [for key in var.app_cluster_map_users :
    {
      userarn  = "${key}"
      username = "admin"
      groups   = ["system:masters"]
  }]

  blk_cluster_map_users_list = [for key in var.blk_cluster_map_users :
    {
      userarn  = "${key}"
      username = "admin"
      groups   = ["system:masters"]
  }]
  dns_entries_list_non_prod = {
    "openidl.${var.aws_env}.${var.domain_info.sub_domain_name}.${var.domain_info.domain_name}" = data.aws_alb.app_nlb.dns_name,
    "app-bastion.${var.aws_env}.${var.domain_info.sub_domain_name}.${var.domain_info.domain_name}" = var.bastion_host_nlb_external ? data.terraform_remote_state.base_setup.outputs.public_app_bastion_dns_name : null,
    "blk-bastion.${var.aws_env}.${var.domain_info.sub_domain_name}.${var.domain_info.domain_name}"= var.bastion_host_nlb_external ? data.terraform_remote_state.base_setup.outputs.public_blk_bastion_dns_name : null,
    "*.ordererorg.${var.aws_env}.${var.domain_info.sub_domain_name}.${var.domain_info.domain_name}" = data.aws_alb.blk_nlb.dns_name,
    "*.${var.org_name}-net.${var.org_name}.${var.aws_env}.${var.domain_info.sub_domain_name}.${var.domain_info.domain_name}" = data.aws_alb.blk_nlb.dns_name,
    "data-call-app-service.${var.aws_env}.${var.domain_info.sub_domain_name}.${var.domain_info.domain_name}" = data.aws_alb.app_nlb.dns_name,
    "insurance-data-manager-service.${var.aws_env}.${var.domain_info.sub_domain_name}.${var.domain_info.domain_name}" = data.aws_alb.app_nlb.dns_name,
    "utilities-service.${var.aws_env}.${var.domain_info.sub_domain_name}.${var.domain_info.domain_name}" = data.aws_alb.app_nlb.dns_name
  }
  dns_entries_list_prod = {
    "openidl.${var.domain_info.sub_domain_name}.${var.domain_info.domain_name}" = data.aws_alb.app_nlb.dns_name,
    "app-bastion.${var.domain_info.sub_domain_name}.${var.domain_info.domain_name}" = var.bastion_host_nlb_external ? data.terraform_remote_state.base_setup.outputs.public_app_bastion_dns_name : null,
    "blk-bastion.${var.domain_info.sub_domain_name}.${var.domain_info.domain_name}" = var.bastion_host_nlb_external ? data.terraform_remote_state.base_setup.outputs.public_blk_bastion_dns_name : null,
    "*.ordererorg.${var.domain_info.sub_domain_name}.${var.domain_info.domain_name}" = data.aws_alb.blk_nlb.dns_name,
    "*.${var.org_name}-net.${var.org_name}.${var.domain_info.sub_domain_name}.${var.domain_info.domain_name}" = data.aws_alb.blk_nlb.dns_name,
    "data-call-app-service.${var.domain_info.sub_domain_name}.${var.domain_info.domain_name}" = data.aws_alb.app_nlb.dns_name,
    "insurance-data-manager-service.${var.domain_info.sub_domain_name}.${var.domain_info.domain_name}" = data.aws_alb.app_nlb.dns_name,
    "utilities-service.${var.domain_info.sub_domain_name}.${var.domain_info.domain_name}" = data.aws_alb.app_nlb.dns_name
  }
}
