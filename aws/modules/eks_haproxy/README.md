# terraform-kubernetes-haproxy-ingress-controller

This module enable HAProxy ingress in EKS Cluster (minimal changes might be needed for other providers) via Terraform.

In AWS, this will trigger kubernetes ingress to create target groups required to not only provide ingress for port 80 and 443, also allow additional ports.

### Sample usage

```
module haproxy-ingress-controller {
  source  = "github.com/sanarena/terraform-kubernetes-haproxy-ingress-controller"
  # however recommended way is to add this repository as a submodule

  # optional
  name = "haproxy"
  load_balancer_source_ranges = ["1.2.3.4/32"]

  #for extra services:
  tcp_services = {
    "panel" = {
      namespace="default"
      service_name="controlpanel"
      container_port="80"
      ingress_port="8081"
    },
    "mysql" = {
      namespace="default"
      service_name="mysql"
      container_port="3306"
      ingress_port="3306"
    }
  }
  udp_services = {
    "openvpn" = {
      namespace="default"
      service_name="openvpn"
      container_port="1194"
      ingress_port="1194"
    }
  }
  lb_annotations = {
    "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
    "service.beta.kubernetes.io/aws-load-balancer-connection-idle-timeout": 360
    "service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags": "environment=test"
  }
}
```
