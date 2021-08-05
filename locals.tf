locals {
  std_name = var.aais || (var.aais && var.other_aws_account) ? "aais-${var.aws_env}" : "carr-${var.aws_env}"
  app_cluster_name = "${local.std_name}-${var.app_cluster_name}"
  blk_cluster_name = "${local.std_name}-${var.blk_cluster_name}"
  policy_arn_prefix = "arn:aws:iam::aws:policy"
  tags = {
    Application = "openidl"
    Environment = var.aws_env
    Managed_by = "terraform"
  }
  bastion_host_userdata = filebase64("resources/bootstrap_scripts/bastion_host.sh")
  worker_nodes_userdata = filebase64("resources/bootstrap_scripts/worker_nodes.sh")
#cognito custom attributes
  custom_attributes = [
    "role",
    "statusCode",
    "stateName",
    "organizationId"]
#application cluster (eks) config-map (aws auth) - iam roles to map
  app_cluster_map_roles = [
    {
      rolearn = aws_iam_role.eks-nodegroup-role["app-node-group"].arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = [
        "system:masters",
        "system:nodes",
        "system:bootstrappers"]
    }]
#blockchain cluster (eks) config-map (aws auth) - iam roles to map
  blk_cluster_map_roles = [
    {
      rolearn = aws_iam_role.eks-nodegroup-role["blk-node-group"].arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = [
        "system:masters",
        "system:nodes",
        "system:bootstrappers"]
    }]
}
