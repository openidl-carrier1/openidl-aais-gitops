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
#provider for application cluster
provider "kubernetes" {
  alias = "app_cluster"
  #config_path = "./kubeconfig_file/kubeconfig_${local.app_cluster_name}"
  host = data.aws_eks_cluster.app_eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.app_eks_cluster.certificate_authority.0.data)
  token = data.aws_eks_cluster_auth.app_eks_cluster_auth.token
  load_config_file = false
}
#provider for blockchain cluster
provider "kubernetes" {
  alias = "blk_cluster"
  #config_path = "./kubeconfig_file/kubeconfig_${local.blk_cluster_name}"
  host = data.aws_eks_cluster.blk_eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.blk_eks_cluster.certificate_authority.0.data)
  token = data.aws_eks_cluster_auth.blk_eks_cluster_auth.token
  load_config_file = false
}
#provider for application cluster
provider "helm" {
  alias = "app_cluster"
  kubernetes {
    host                   = data.aws_eks_cluster.app_eks_cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.app_eks_cluster.certificate_authority.0.data)
    config_path            = "./kubeconfig_file/kubeconfig_${local.app_cluster_name}"
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.app_eks_cluster.name]
      command     = "aws"
    }
  }
}
#provider for blockchain cluster
provider "helm" {
  alias = "blk_cluster"
  kubernetes {
    host                   = data.aws_eks_cluster.blk_eks_cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.blk_eks_cluster.certificate_authority.0.data)
    config_path            = "./kubeconfig_file/kubeconfig_${local.blk_cluster_name}"
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.blk_eks_cluster.name]
      command     = "aws"
    }
  }
}