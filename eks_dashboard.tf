#application cluster (eks) dashboard
resource "helm_release" "app_eks_dashboard" {
  provider = helm.app_cluster
  name = "${local.std_name}-app-eks-dashboard"
  repository = 	"https://kubernetes.github.io/dashboard/"
  chart = "kubernetes-dashboard"
  version =  "4.3.1"
  create_namespace = true
  namespace = "kubernetes-dashboard"
  cleanup_on_fail = true
  timeout = 600
  #values = [file("resources/k8s/eks_dashboard.yaml")]
  depends_on = [module.app_eks_cluster]
  set {
    name  = "ingress.enabled"
    value = "true"
  }
  set {
    name = "ingress.hosts[0]"
    value = "${var.app_k8s_dashboard_subdomain}${var.app_k8s_dashboard_domain}"
  }
  set {
    name  = "ingress.tls[0].hosts[0]"
    value = "${var.app_k8s_dashboard_subdomain}${var.app_k8s_dashboard_domain}"
  }
  set {
    name  = "ingress.tls[0].secretName"
    value = "yes"
  }
  set {
    name  = "ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/whitelist-source-range"
    value = replace(var.cidr_whitelist, ",", "\\,")
    type  = "string"
  }
  set {
    name  = "metricsScraper.enabled"
    value = "true"
  }
  set {
    name  = "metrics-server.enabled"
    value = "true"
  }
  set {
    name  = "rbac.clusterReadOnlyRole"
    value = true
  }
}
#application cluster (eks) dashboard eks-admin service account and cluster role binding
resource "kubernetes_service_account" "app_eks_admin_service_account" {
  provider = kubernetes.app_cluster
  metadata {
    name      = "app-eks-admin"
    namespace = "kubernetes-dashboard"
      }
  automount_service_account_token = true
  depends_on = [module.app_eks_cluster, helm_release.app_eks_dashboard]
}
resource "kubernetes_cluster_role_binding" "app_eks_admin_role_binding" {
    provider = kubernetes.app_cluster
    metadata {
    name = "app-eks-admin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.app_eks_admin_service_account.metadata[0].name
    namespace = "kubernetes-dashboard"
  }
  depends_on = [module.app_eks_cluster, helm_release.app_eks_dashboard]
}
data "kubernetes_secret" "app_eks_admin_token" {
  provider = kubernetes.app_cluster
  metadata {
    name      = kubernetes_service_account.app_eks_admin_service_account.default_secret_name
    namespace = "kubernetes-dashboard"
  }
  depends_on = [module.app_eks_cluster, kubernetes_service_account.app_eks_admin_service_account]
}
#blockchain cluster (eks) dashboard
resource "helm_release" "blk_eks_dashboard" {
  provider = helm.blk_cluster
  name = "${local.std_name}-blk-eks-dashboard"
  repository = 	"https://kubernetes.github.io/dashboard/"
  chart = "kubernetes-dashboard"
  version =  "4.3.1"
  create_namespace = true
  namespace = "kubernetes-dashboard"
  cleanup_on_fail = true
  timeout = 600
  #values = [file("resources/k8s/eks_dashboard.yaml")]
  depends_on = [module.blk_eks_cluster]
  set {
    name  = "ingress.enabled"
    value = "true"
  }
  set {
    name = "ingress.hosts[0]"
    value = "${var.blk_k8s_dashboard_subdomain}${var.blk_k8s_dashboard_domain}"
  }
  set {
    name  = "ingress.tls[0].hosts[0]"
    value = "${var.blk_k8s_dashboard_subdomain}${var.blk_k8s_dashboard_domain}"
  }
  set {
    name  = "ingress.tls[0].secretName"
    value = "yes"
  }
  set {
    name  = "ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/whitelist-source-range"
    value = replace(var.cidr_whitelist, ",", "\\,")
    type  = "string"
  }
  set {
    name  = "metricsScraper.enabled"
    value = "true"
  }
  set {
    name  = "metrics-server.enabled"
    value = "true"
  }
  set {
    name  = "rbac.clusterReadOnlyRole"
    value = true
  }
}
#blockchain cluster (eks) dashboard eks-admin service account and cluster role binding
resource "kubernetes_service_account" "blk_eks_admin_service_account" {
  provider = kubernetes.blk_cluster
  metadata {
    name      = "blk-eks-admin"
    namespace = "kubernetes-dashboard"
      }
  automount_service_account_token = true
  depends_on = [module.blk_eks_cluster, helm_release.blk_eks_dashboard]
}
resource "kubernetes_cluster_role_binding" "blk_eks_admin_role_binding" {
    provider = kubernetes.blk_cluster
    metadata {
    name = "blk-eks-admin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.blk_eks_admin_service_account.metadata[0].name
    namespace = "kubernetes-dashboard"
  }
  depends_on = [module.blk_eks_cluster, helm_release.blk_eks_dashboard]
}
data "kubernetes_secret" "blk_eks_admin_token" {
  provider = kubernetes.blk_cluster
  metadata {
    name      = kubernetes_service_account.blk_eks_admin_service_account.default_secret_name
    namespace = "kubernetes-dashboard"
    }
  depends_on = [module.blk_eks_cluster, kubernetes_service_account.blk_eks_admin_service_account]
}
