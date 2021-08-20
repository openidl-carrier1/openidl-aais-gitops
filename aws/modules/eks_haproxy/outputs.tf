output "lb_address" {
  value       = length(kubernetes_service.lb.load_balancer_ingress) > 0 ? (length(kubernetes_service.lb.load_balancer_ingress[0].ip) > 0 ? kubernetes_service.lb.load_balancer_ingress[0].ip : kubernetes_service.lb.load_balancer_ingress[0].hostname) : "127.0.0.1"
  # value       = "example.org"
  description = "The hostname of the LB created by kubernetes"
}

output "ingress_class" {
  value = var.name
}