locals {
  std_name = var.aais || (var.aais && var.other_aws_account) ? "aais-${var.aws_env}" : "carrier-${var.aws_env}"
  #policy_arn_prefix              = "arn:aws:iam::aws:policy"
  #target_groups_name             = "tg-${var.aws_env}"
  #app_eks_target_groups_name     = "tg-${var.aws_env}"
  #dashboard_chart                 = "kubernetes-dashboard"
  #dashboard_admin_service_account = "kubernetes-dashboard-admin"
  #dashboard_repository            = "https://kubernetes.github.io/dashboard/"
  tags = {
    Application = "openidl"
    Environment = var.aws_env
    Managed_by = "terraform"
  }
  bastion_host_userdata = filebase64("resources/bastion_host.sh")
  #cognito custom attributes
  custom_attributes = ["role", "statusCode", "stateName", "organizationId"]
}
