variable "name" {
  description = "The name of this haproxy ingress controller"
  type        = string
  default     = "haproxy"
}

variable "haproxy_config" {
  description = "Data in the k8s config map."
  default     = {}
}

variable "lb_annotations" {
  description = "Annotations to add to the loadbalancer"
  type        = map(string)
  default = {
    "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
  }
}

variable "load_balancer_source_ranges" {
  description = "The ip whitelist that is allowed to access the load balancer"
  default     = ["0.0.0.0/0"]
  type        = list(string)
}

variable "lb_ports" {
  description = "Load balancer port configuration"
  type = list(object({
    name        = string
    port        = number
    target_port = string
    protocol    = string
  }))
  default = [{
    name        = "http"
    port        = 80
    target_port = "http"
    protocol    = "TCP"
    }, {
    name        = "https"
    port        = 443
    target_port = "https"
    protocol    = "TCP"
  }]
}

variable "priority_class_name" {
  description = "The priority class to attach to the deployment"
  type        = string
  default     = "system-cluster-critical"
}

variable "controller_replicas" {
  description = "Desired number of replicas of the haproxy ingress controller pod"
  type        = number
  default     = 1
}

variable "tcp_services" {
  description = "List of extra TCP services"
  default = {}
}

variable "udp_services" {
  description = "List of extra UDP services"
  default = {}
}