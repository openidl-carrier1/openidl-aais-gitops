locals {
  stdname = var.cluster_type == "app_cluster" ? "aais-${var.aws_env}-app" : "aais-${var.aws_env}-blk"
  cluster_name                   = "${var.application_name}-app-eks-${random_string.suffix.result}"
  policy_arn_prefix              = "arn:aws:iam::aws:policy"
  app_eks_nlb_name               = "${var.application_name}app-eks-nlb-${var.aws_env}"
  target_groups_name             = "tg-${var.aws_env}"
  app_bastion_target_groups_name = "tg-${var.aws_env}"
  app_eks_target_groups_name     = "tg-${var.aws_env}"
  bucket_name                     = "${var.application_name}-s3-bucket-${random_pet.this.id}"
  bastion_ec2_name                = "${var.application_name}-bastion-ec2-${var.aws_env}"
  app_bastion_nlb_name           = "${var.application_name}app-bastion-nlb-${var.aws_env}"
  dashboard_chart                 = "kubernetes-dashboard"
  dashboard_admin_service_account = "kubernetes-dashboard-admin"
  dashboard_repository            = "https://kubernetes.github.io/dashboard/"
  tags = {
    application = "openidl"
    managed_by = "terraform"
    cluster_type = var.cluster_type
    environment = var.aws_env
  }
  #bastion_host_userdata = filebase64("resources/bastion_host.sh")
  #ec2_userdata = filebase64("resources/apache.sh")
}
