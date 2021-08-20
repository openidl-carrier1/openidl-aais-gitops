locals {
  tcp_services_tuple = flatten([
      for service_name, values in var.tcp_services : {
        key=(values.ingress_port)
        val="${values.namespace}/${values.service_name}:${values.container_port}"
      }
  ])
  tcp_services_map = { for item in local.tcp_services_tuple: item.key => item.val }
}

locals {
  udp_services_tuple = flatten([
      for service_name, values in var.udp_services : {
        key=(values.ingress_port)
        val="${values.namespace}/${values.service_name}:${values.container_port}"
      }
  ])
  udp_services_map = { for item in local.udp_services_tuple: item.key => item.val }
}


locals {
  lb_ports=concat(concat( flatten([
      for service_name, values in var.tcp_services : {
        name="${service_name}tcp"
        port=values.ingress_port
        target_port=values.ingress_port
        protocol="TCP"
      }
  ]),flatten([
      for service_name, values in var.udp_services : {
        name="${service_name}udp"
        port=values.ingress_port
        target_port=values.ingress_port
        protocol="UDP"
      }
  ])),var.lb_ports)
}