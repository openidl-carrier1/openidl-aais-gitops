#Define required providers configuration when using local terraform workspace
/*
provider "aws" {
  region = var.aws_region
  assume_role {
    role_arn     = ""
    session_name = "terraform-session"
    external_id  = "terraform"

}
*/
#required when used in github actions pipeline
provider "aws" {
  region = var.aws_region
}
provider "kubernetes" {
  alias = "app_cluster"
  config_path = "./kubeconfig_file/kubeconfig_${local.app_cluster_name}"
  host = data.aws_eks_cluster.app_eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.app_eks_cluster.certificate_authority.0.data)
  token = data.aws_eks_cluster_auth.app_eks_cluster_auth.token
  load_config_file = true
}

provider "kubernetes" {
  alias = "blk_cluster"
  config_path = "./kubeconfig_file/kubeconfig_${local.blk_cluster_name}"
  host = data.aws_eks_cluster.blk_eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.blk_eks_cluster.certificate_authority.0.data)
  token = data.aws_eks_cluster_auth.blk_eks_cluster_auth.token
  load_config_file = true
}
