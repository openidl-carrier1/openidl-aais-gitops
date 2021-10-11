#setting up ha proxy in app cluster
resource "helm_release" "app_haproxy" {
  depends_on = [data.aws_eks_cluster.app_eks_cluster, data.aws_eks_cluster_auth.app_eks_cluster_auth, kubernetes_config_map.app_config_map]
  provider = helm.app_cluster
  cleanup_on_fail = true
  create_namespace = true
  name = "haproxy-ingress"
  chart ="resources/helm/haproxy"
  namespace = "app-ingress-controller"
  timeout = 600
  force_update = true
  wait = true
  wait_for_jobs = true
  values = ["${file("resources/helm/haproxy/values.yaml")}"]
}
#setting up ha proxy in blk cluster
resource "helm_release" "blk_haproxy" {
  depends_on = [data.aws_eks_cluster.blk_eks_cluster, data.aws_eks_cluster_auth.blk_eks_cluster_auth, kubernetes_config_map.blk_config_map]
  provider = helm.blk_cluster
  cleanup_on_fail = true
  create_namespace = true
  name = "haproxy-ingress"
  chart ="resources/helm/haproxy"
  namespace = "blk-ingress-controller"
  timeout = 600
  force_update = true
  wait = true
  wait_for_jobs = true
  values = ["${file("resources/helm/haproxy/values.yaml")}"]
}
