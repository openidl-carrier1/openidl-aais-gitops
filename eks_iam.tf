#iam role for application cluster and blockchain cluster (eks)
resource "aws_iam_role" "eks_cluster_role" {
  for_each = toset(["app-eks", "blk-eks"])
  name = "${local.std_name}-${each.value}-${var.aws_region}" #remove this aws_region from the name
  assume_role_policy = file("resources/policies/cluster-role-trust-policy.json")
  tags = merge(
    local.tags,
    {
      "Name" = "${local.std_name}-${each.value}"
      "Cluster_type" = "${each.value}"
    },)
}
resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  for_each = toset(["app-eks", "blk-eks"])
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role["${each.value}"].id
}
resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSVPCResourceController" {
  for_each = toset(["app-eks", "blk-eks"])
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSVPCResourceController"
  #role       = aws_iam_role.app-eks-cluster.name
  role       = aws_iam_role.eks_cluster_role["${each.value}"].id
}
resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSServicePolicy" {
  for_each = toset(["app-eks", "blk-eks"])
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster_role["${each.value}"].id
}
resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSCNIPolicy" {
  for_each = toset(["app-eks", "blk-eks"])
  policy_arn = "${local.policy_arn_prefix}/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_cluster_role["${each.value}"].id
}
resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSWorkerNodePolicy" {
  for_each = toset(["app-eks", "blk-eks"])
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_cluster_role["${each.value}"].id
}
resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEC2ContainerRegistryReadOnly" {
  for_each = toset(["app-eks", "blk-eks"])
  policy_arn = "${local.policy_arn_prefix}/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_cluster_role["${each.value}"].id
}
#iam role for worker groups of both application cluster and blockchain cluster (eks)
resource "aws_iam_role" "eks_nodegroup_role" {
  for_each = toset(["app-node-group", "blk-node-group"])
  name = "${local.std_name}-${each.value}-${var.aws_region}" #remove aws_region from the name
  assume_role_policy = file("resources/policies/nodegroup-role-trust-policy.json")
  tags = merge(
    local.tags,
    {
      "Name" = "${local.std_name}-${each.value}"
      "Cluster_node_group" = "${each.value}"
    },)
}
resource "aws_iam_role_policy_attachment" "eks_nodegroup_AmazonEKSWorkerNodePolicy" {
  for_each = toset(["app-node-group", "blk-node-group"])
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodegroup_role["${each.value}"].id
}
resource "aws_iam_role_policy_attachment" "eks_nodegroup_AmazonEC2ContainerRegistryReadOnly" {
  for_each = toset(["app-node-group", "blk-node-group"])
  policy_arn = "${local.policy_arn_prefix}/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodegroup_role["${each.value}"].id
}
resource "aws_iam_role_policy_attachment" "eks_nodegroup_AmazonEKSCNIPolicy" {
  for_each = toset(["app-node-group", "blk-node-group"])
  policy_arn = "${local.policy_arn_prefix}/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodegroup_role["${each.value}"].id
}
#iam policy for the worker nodes to manage csi driver for persistent volumes
resource "aws_iam_policy" "eks_worker_node_ebs_policy" {
  name = "AmazonEBS_CSI_Driver"
  policy = file("resources/policies/nodegroup-role-ebs-ci-driver-policy.json")
  tags = merge(local.tags,
  { "Name" = "${local.std_name}-AmazonEBS_CSI_Driver",
    "Cluster_type" = "both" })
}
resource "aws_iam_role_policy_attachment" "eks_nodegroup_AmazonEKSEBSCSIDriverPolicy" {
  for_each = toset(["app-node-group", "blk-node-group"])
  policy_arn = aws_iam_policy.eks_worker_node_ebs_policy.arn
  role       = aws_iam_role.eks_nodegroup_role["${each.value}"].id
}