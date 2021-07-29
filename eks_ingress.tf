/*
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    config_path            = "./kubeconfig_file/kubeconfig_${local.cluster_name}"
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
      command     = "aws"
    }
  }
}
resource "helm_release" "nginx_ingress" {
  count      = var.nginx_ingress_enabled ? 1 : 0
  name       = "nginx-ingress-controller"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"
  create_namespace = true
  set {
    name  = "service.type"
    value = "ClusterIP"
  }
  values = [
    file("${path.module}/resources/eks-nginx-ingress.deploy.yaml")]
  depends_on = [
    module.app_eks
  ]
}
*/