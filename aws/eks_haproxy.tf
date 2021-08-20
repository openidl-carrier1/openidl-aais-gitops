resource "helm_release" "app_haproxy" {
  provider = helm.app-eks
  cleanup_on_fail = true
  create_namespace = true
  name = "haproxy-ingress"
  chart ="resources/helm/haproxy"
  namespace = "app-eks-ingress-controller"
  values = ["${file("resources/helm/haproxy/values.yaml")}"]
}
resource "helm_release" "blk_haproxy" {
  provider = helm.blk-eks
  cleanup_on_fail = true
  create_namespace = true
  name = "haproxy-ingress"
  chart ="resources/helm/haproxy"
  namespace = "blk-eks-ingress-controller"
  values = ["${file("resources/helm/haproxy/values.yaml")}"]
}
