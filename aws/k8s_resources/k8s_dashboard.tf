/*
#setting up ha proxy in app cluster
resource "helm_release" "app_k8s_dashboard" {
  depends_on = [data.aws_eks_cluster.app_eks_cluster, data.aws_eks_cluster_auth.app_eks_cluster_auth, kubernetes_config_map.app_config_map]
  provider = helm.app_cluster
  cleanup_on_fail = true
  create_namespace = true
  name = "kubernetes-dashboard"
  chart ="resources/helm/kubernetes-dashboard"
  namespace = "kubernetes-dashboard"
  timeout = 600
  force_update = true
  wait = true
  wait_for_jobs = true
  values = ["${file("resources/helm/kubernetes-dashboard/values.yaml")}"]
}
#setting up ha proxy in blk cluster
resource "helm_release" "blk-k8s_dashboard" {
  depends_on = [data.aws_eks_cluster.blk_eks_cluster, data.aws_eks_cluster_auth.blk_eks_cluster_auth, kubernetes_config_map.blk_config_map]
  provider = helm.blk_cluster
  cleanup_on_fail = true
  create_namespace = true
  name = "kubernetes-dashboard"
  chart ="resources/helm/kubernetes-dashboard"
  namespace = "kubernetes-dashboard"
  timeout = 600
  force_update = true
  wait = true
  wait_for_jobs = true
  values = ["${file("resources/helm/kubernetes-dashboard/values.yaml")}"]
}*/