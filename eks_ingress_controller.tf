module "app_eks_nginx_controller" {
  source = "terraform-iaac/nginx-controller/kubernetes"
  name = "ingress-nginx"
  namespace_name = "kube-system"
  controller_kind = "DaemonSet"
  controller_daemonset_useHostPort = false
  controller_service_externalTrafficPolicy = "Local"
  controller_request_memory = "140"
  publish_service = true
  define_nodePorts = true
  service_nodePort_http = "32001"
  service_nodePort_https = "32002"
  metrics_enabled = "true"
  disable_heavyweight_metrics = false
  additional_set = [
    {
      name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
      value = "nlb"
      type  = "string"
    },
    {
      name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-cross-zone-load-balancing-enabled"
      value = "true"
      type  = "string"
    }
  ]
}