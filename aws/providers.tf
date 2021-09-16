#required when used in github actions pipeline
provider "aws" {
  region = var.aws_region
}
provider "kubernetes" {
  alias                  = "app_cluster"
  host                   = module.app_eks_cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(module.app_eks_cluster.cluster_certificate_authority_data)
  token                  = module.app_eks_cluster.aws_eks_cluster_auth[0].token
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", module.app_eks_cluster.aws_eks_cluster[0].name]
    command     = "aws"
  }

}
#provider for blockchain cluster (kubernetes)
provider "kubernetes" {
  alias                  = "blk_cluster"
  host                   = module.blk_eks_cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(module.blk_eks_cluster.cluster_certificate_authority_data)
  token                  = module.blk_eks_cluster.aws_eks_cluster_auth[0].token
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", module.blk_eks_cluster.aws_eks_cluster[0].name]
    command     = "aws"
  }

}
#provider for application cluster (helm)
provider "helm" {
  alias = "app_cluster"
  kubernetes {
    host                   = module.app_eks_cluster.cluster_endpoint
    cluster_ca_certificate = base64decode(module.app_eks_cluster.cluster_certificate_authority_data)
    token                  = module.app_eks_cluster.aws_eks_cluster_auth[0].token
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", module.app_eks_cluster.aws_eks_cluster[0].name]
      command     = "aws"
    }
  }
}
#provider for application cluster (helm)
provider "helm" {
  alias = "blk_cluster"
  kubernetes {
    host                   = module.blk_eks_cluster.cluster_endpoint
    cluster_ca_certificate = base64decode(module.blk_eks_cluster.cluster_certificate_authority_data)
    token                  = module.blk_eks_cluster.aws_eks_cluster_auth[0].token
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", module.blk_eks_cluster.aws_eks_cluster[0].name]
      command     = "aws"
    }
  }
}
