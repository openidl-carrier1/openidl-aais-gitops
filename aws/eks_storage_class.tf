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
  #mount_options = ["file_mode=0700", "dir_mode=0777", "mfsymlinks", "uid=1000", "gid=1000", "nobrl", "cache=none"]
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
  #mount_options = ["file_mode=0700", "dir_mode=0777", "mfsymlinks", "uid=1000", "gid=1000", "nobrl", "cache=none"]
}

