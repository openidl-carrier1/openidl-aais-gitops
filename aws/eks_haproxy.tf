resource "helm_release" "app_haproxy" {
  depends_on = [module.app_eks_cluster]
  provider = helm.app_cluster
  cleanup_on_fail = true
  create_namespace = true
  name = "haproxy-ingress"
  chart ="resources/helm/haproxy"
  namespace = "app-eks-ingress-controller"
  values = ["${file("resources/helm/haproxy/values.yaml")}"]
}
resource "helm_release" "blk_haproxy" {
  depends_on = [module.blk_eks_cluster]
  provider = helm.blk_cluster
  cleanup_on_fail = true
  create_namespace = true
  name = "haproxy-ingress"
  chart ="resources/helm/haproxy"
  namespace = "blk-eks-ingress-controller"
  values = ["${file("resources/helm/haproxy/values.yaml")}"]
}
