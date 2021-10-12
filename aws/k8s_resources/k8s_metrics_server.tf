/*
#setting up metrics server in app cluster
resource "helm_release" "app_metrics_server" {
  depends_on = [data.aws_eks_cluster.app_eks_cluster, data.aws_eks_cluster_auth.app_eks_cluster_auth, kubernetes_config_map.app_config_map]
  provider = helm.app_cluster
  cleanup_on_fail = true
  create_namespace = true
  name = "metrics-server"
  chart ="resources/helm/metrics-server"
  timeout = 600
  force_update = true
  wait = true
  wait_for_jobs = true
  values = ["${file("resources/helm/metrics-server/values.yaml")}"]
}
#setting up metrics server in blk cluster
resource "helm_release" "blk_metrics_server" {
  depends_on = [data.aws_eks_cluster.blk_eks_cluster, data.aws_eks_cluster_auth.blk_eks_cluster_auth, kubernetes_config_map.blk_config_map]
  provider = helm.blk_cluster
  cleanup_on_fail = true
  create_namespace = true
  name = "metrics-server"
  chart ="resources/helm/metrics-server"
  timeout = 600
  force_update = true
  wait = true
  wait_for_jobs = true
  values = ["${file("resources/helm/metrics-server/values.yaml")}"]
}
*/