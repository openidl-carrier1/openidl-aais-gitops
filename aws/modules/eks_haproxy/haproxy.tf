resource "kubernetes_namespace" "haproxy" {
  metadata {
    name = var.name

    labels = {
      "app.kubernetes.io/name"       = var.name
      "app.kubernetes.io/part-of"    = var.name
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}

resource "kubernetes_config_map" "haproxy_config" {
  metadata {
    name      = "${var.name}-config-map"
    namespace = kubernetes_namespace.haproxy.metadata.0.name

    labels = {
      "app.kubernetes.io/name"       = var.name
      "app.kubernetes.io/part-of"    = kubernetes_namespace.haproxy.metadata.0.name
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  data = var.haproxy_config
}

resource "kubernetes_config_map" "haproxy_tcp" {
  metadata {
    name      = "${var.name}-tcp-services"
    namespace = kubernetes_namespace.haproxy.metadata.0.name

    labels = {
      "app.kubernetes.io/name"       = var.name
      "app.kubernetes.io/part-of"    = kubernetes_namespace.haproxy.metadata.0.name
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
  data = local.tcp_services_map

}

resource "kubernetes_config_map" "haproxy_udp" {
  metadata {
    name      = "${var.name}-udp-services"
    namespace = kubernetes_namespace.haproxy.metadata.0.name

    labels = {
      "app.kubernetes.io/name"       = var.name
      "app.kubernetes.io/part-of"    = kubernetes_namespace.haproxy.metadata.0.name
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

 data = local.udp_services_map
}

resource "kubernetes_service_account" "haproxy" {
  automount_service_account_token = "true"
  metadata {
    name      = "${var.name}-ingress-service-account"
    namespace = kubernetes_namespace.haproxy.metadata.0.name

    labels = {
      "app.kubernetes.io/name"       = var.name
      "app.kubernetes.io/part-of"    = kubernetes_namespace.haproxy.metadata.0.name
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}

resource "kubernetes_cluster_role" "haproxy" {
  metadata {
    name = "${var.name}-ingress-cluster-role"

    labels = {
      "app.kubernetes.io/name"       = var.name
      "app.kubernetes.io/part-of"    = kubernetes_namespace.haproxy.metadata.0.name
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps", "endpoints", "nodes", "pods", "services","namespaces","events","serviceaccounts"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["extensions"]
    resources  = ["ingresses", "ingresses/status"]
    verbs      = ["get","list","watch","update"]
  }

  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["get", "list", "watch","create","patch","update"]
  }
}

resource "kubernetes_cluster_role_binding" "haproxy" {
  metadata {
    name      = "${var.name}-role-binding"

    labels = {
      "app.kubernetes.io/name"       = var.name
      "app.kubernetes.io/part-of"    = kubernetes_namespace.haproxy.metadata.0.name
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.haproxy.metadata.0.name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.haproxy.metadata.0.name
    namespace = kubernetes_service_account.haproxy.metadata.0.namespace
  }
}

resource "kubernetes_deployment" "haproxy" {
  metadata {
    name      = "${var.name}-default-backend"
    namespace = kubernetes_namespace.haproxy.metadata.0.name

    labels = {
      "run"                          = "${var.name}-default-backend"
      "app.kubernetes.io/name"       = var.name
      "app.kubernetes.io/part-of"    = kubernetes_namespace.haproxy.metadata.0.name
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  spec {
    replicas = var.controller_replicas

    selector {
      match_labels = {
        "run"                       = "${var.name}-default-backend"
      }
    }

    template {
      metadata {
        labels = {
          "run"                       = "${var.name}-default-backend"
        }

        # annotations = {
        # }
      }

      spec {
        // wait up to 2 minutes to drain connections
        termination_grace_period_seconds = 100
        service_account_name             = kubernetes_service_account.haproxy.metadata.0.name
        priority_class_name              = var.priority_class_name

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              topology_key = "kubernetes.io/hostname"
              label_selector {
                match_expressions {
                key      = "app.kubernetes.io/name"
                operator = "In"
                values   = ["ingress-haproxy"]
                }
              }
            }
          }
          node_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 1
              preference {
                match_expressions {
                key      = "restart"
                operator = "In"
                values   = ["unlikely"]
                }
              }
            }
          }
        }
        # topologySpreadConstraints do same, but not implemented in terraform v0.14.3 yet.
        # topologySpreadConstraints:
        #   - labelSelector:
        #       matchLabels:
        #         app.kubernetes.io/name: ingress-haproxy
        #     maxSkew: 1
        #     topologyKey: kubernetes.io/hostname


        toleration {
          effect = "NoSchedule"
          key = "onlyfor"
          operator = "Equal"
          value = "highcpu"
        }
        toleration {
          effect = "NoSchedule"
          key = "dbonly"
          operator = "Equal"
          value = "yes"
        }

        container {
          name  = "${var.name}-ingress-default-backend"
          image = "gcr.io/google_containers/defaultbackend:1.0"

          port {
            name           = "http"
            container_port = 8080
            protocol       = "TCP"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "backend" {
  metadata {
    name = "${var.name}-default-backend"
    namespace = kubernetes_namespace.haproxy.metadata.0.name
    labels = {
      "run" = "${var.name}-default-backend"
    }
  }
  spec {
    selector = {
      "run" = "${var.name}-default-backend"
    }

    port {
      name        = "port-1"
      port        = "8080"
      target_port = "8080"
      protocol    = "TCP"
    }
  }
}










resource "kubernetes_deployment" "ingress" {
  metadata {
    name      = "${var.name}-ingress"
    namespace = kubernetes_namespace.haproxy.metadata.0.name

    labels = {
      "run"                          = "${var.name}-ingress"
      "app.kubernetes.io/name"       = var.name
      "app.kubernetes.io/part-of"    = kubernetes_namespace.haproxy.metadata.0.name
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  spec {
    replicas = var.controller_replicas

    selector {
      match_labels = {
        "run"    = "${var.name}-ingress"
      }
    }

    template {
      metadata {
        labels = {
          "run"                       = "${var.name}-ingress"
        }
      }

      spec {
        // wait up to 2 minutes to drain connections
        termination_grace_period_seconds = 100
        service_account_name             = kubernetes_service_account.haproxy.metadata.0.name
        priority_class_name              = var.priority_class_name

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              topology_key = "kubernetes.io/hostname"
              label_selector {
                match_expressions {
                key      = "app.kubernetes.io/name"
                operator = "In"
                values   = [var.name]
                }
              }
            }
          }
          node_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 1
              preference {
                match_expressions {
                key      = "restart"
                operator = "In"
                values   = ["unlikely"]
                }
              }
            }
          }
        }
        # topologySpreadConstraints do same, but not implemented in terraform v0.14.3 yet.
        # topologySpreadConstraints:
        #   - labelSelector:
        #       matchLabels:
        #         app.kubernetes.io/name: haproxy
        #     maxSkew: 1
        #     topologyKey: kubernetes.io/hostname


        toleration {
          effect = "NoSchedule"
          key = "onlyfor"
          operator = "Equal"
          value = "highcpu"
        }
        toleration {
          effect = "NoSchedule"
          key = "dbonly"
          operator = "Equal"
          value = "yes"
        }

        container {
          name  = "${var.name}-ingress-controller"
          image = "haproxytech/kubernetes-ingress"

          args = [
            "--configmap=${kubernetes_namespace.haproxy.metadata.0.name}/${kubernetes_config_map.haproxy_config.metadata.0.name}",
            "--configmap-tcp-services=${kubernetes_namespace.haproxy.metadata.0.name}/${kubernetes_config_map.haproxy_tcp.metadata.0.name}",
            "--configmap-udp-services=${kubernetes_namespace.haproxy.metadata.0.name}/${kubernetes_config_map.haproxy_udp.metadata.0.name}",
            "--publish-service=${kubernetes_namespace.haproxy.metadata.0.name}/${var.name}-ingress",
            "--default-backend-service=${kubernetes_namespace.haproxy.metadata.0.name}/${var.name}-default-backend",
            "--ingress-class=${var.name}",
          ]

          volume_mount {
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
            name       = kubernetes_service_account.haproxy.default_secret_name
            read_only  = true
          }

          resources {
            requests {
              cpu = "500m"
              memory = "50Mi"
            }
          }

          env {
            name = "POD_NAME"
            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }

          env {
            name = "POD_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          port {
            name           = "http"
            container_port = 80
            protocol       = "TCP"
          }

          port {
            name           = "https"
            container_port = 443
            protocol       = "TCP"
          }

          port {
            name           = "stat"
            container_port = 1024
            protocol       = "TCP"
          }
          liveness_probe {
            failure_threshold = 3
            http_get {
              path   = "/healthz"
              port   = 1042
              scheme = "HTTP"
            }
          }
        }

        volume {
          name = kubernetes_service_account.haproxy.default_secret_name

          secret {
            secret_name = kubernetes_service_account.haproxy.default_secret_name
          }
        }
      }
    }
  }
}

