#storage class for the application cluster
resource "kubernetes_storage_class" "app_storage_class_aws_ebs" {
  provider   = kubernetes.app_cluster
  depends_on = [module.app_eks_cluster]
  metadata {
    name        = "openidl-sc"
    annotations = { "storageclass.kubernetes.io/is-default-class" = "true" }
  }
  storage_provisioner    = "kubernetes.io/aws-ebs"
  reclaim_policy         = "Retain"
  volume_binding_mode    = "WaitForFirstConsumer"
  allow_volume_expansion = "true"
  parameters = {
    type      = "gp2"
    encrypted = "true"
    fsType    = "ext4"
  }
}
#storage class for the blockchain cluster
resource "kubernetes_storage_class" "blk_storage_class_aws_ebs" {
  provider   = kubernetes.blk_cluster
  depends_on = [module.blk_eks_cluster]
  metadata {
    name        = "openidl-sc"
    annotations = { "storageclass.kubernetes.io/is-default-class" = "true" }
  }
  storage_provisioner    = "kubernetes.io/aws-ebs"
  reclaim_policy         = "Retain"
  volume_binding_mode    = "WaitForFirstConsumer"
  allow_volume_expansion = "true"
  parameters = {
    type      = "gp2"
    encrypted = "true"
    fsType    = "ext4"
  }
}

