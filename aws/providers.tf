#required when used in github actions pipeline
provider "aws" {
  region = var.aws_region
}
#provider for application cluster (kubernetes)
provider "kubernetes" {
  alias                  = "app_cluster"
  host                   = data.aws_eks_cluster.app_eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.app_eks_cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.app_eks_cluster_auth.token
  #load_config_file       = false
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", "${data.aws_eks_cluster.app_eks_cluster.name}"]
    command     = "aws"
  }

}
#provider for blockchain cluster (kubernetes)
provider "kubernetes" {
  alias                  = "blk_cluster"
  host                   = data.aws_eks_cluster.blk_eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.blk_eks_cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.blk_eks_cluster_auth.token
  #load_config_file       = false
   exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", "${data.aws_eks_cluster.blk_eks_cluster.name}"]
    command     = "aws"
  }

}
#provider for application cluster (helm)
provider "helm" {
  alias = "app_cluster"
  kubernetes {
    host                   = data.aws_eks_cluster.app_eks_cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.app_eks_cluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.app_eks_cluster.name]
      command     = "aws"
    }
  }
}
#provider for application cluster (helm)
provider "helm" {
  alias = "blk_cluster"
  kubernetes {
    host                   = data.aws_eks_cluster.blk_eks_cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.blk_eks_cluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.blk_eks_cluster.name]
      command     = "aws"
    }
  }
}
/*
provider "kubernetes" {
  alias = "app_cluster"
  config_path = "~/.kube/config"
  load_config_file = true
  config_context = "app_cluster"
}
provider "kubernetes" {
  alias = "blk_cluster"
  config_path = "~/.kube/config"
  load_config_file = true
  config_context = "blk_cluster"
}
provider "helm" {
  alias = "app-eks"
  kubernetes {

    config_path = "~/.kube/config"
    config_context = "app_cluster"
  }
}
provider "helm" {
  alias = "blk-eks"
  kubernetes {

    config_path = "~/.kube/config"
    config_context = "blk_cluster"
  }
}*/