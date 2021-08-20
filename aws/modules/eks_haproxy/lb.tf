resource "kubernetes_service" "lb" {
  metadata {
    name = "${var.name}-ingress"
    namespace = kubernetes_namespace.haproxy.metadata.0.name
    labels = {
      "run" = "${var.name}-ingress"
    }
    annotations = var.lb_annotations
  }
  spec {
    
    type = "LoadBalancer"
    external_traffic_policy = "Local"

    selector = {
      "run" = "${var.name}-ingress"
    }

    dynamic "port" {
      for_each = local.lb_ports

      content {
        name        = port.value.name
        port        = port.value.port
        target_port = port.value.target_port
        protocol    = port.value.protocol
      }
    }
    load_balancer_source_ranges = var.load_balancer_source_ranges
  }
}