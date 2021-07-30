/*
resource "aws_iam_role" "app-eks-cluster" {
  name = "${local.std_name}-eks"
  assume_role_policy = <<POLICY
 {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
  tags = merge(
    local.tags,
    {
      "name" = "${local.std_name}-eks"
    },)
}
resource "aws_iam_role_policy_attachment" "app-eks-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSClusterPolicy"
  role       = aws_iam_role.app-eks-cluster.name
}
resource "aws_iam_role_policy_attachment" "app-eks-cluster-AmazonEKSVPCResourceController" {
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSVPCResourceController"
  role       = aws_iam_role.app-eks-cluster.name
}
resource "aws_iam_role_policy_attachment" "app-eks-cluster-AmazonEKSServicePolicy" {
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSServicePolicy"
  role       = aws_iam_role.app-eks-cluster.name
}
resource "aws_iam_role_policy_attachment" "app-eks-cluster-AmazonEKS_CNI_Policy" {
  policy_arn = "${local.policy_arn_prefix}/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.app-eks-cluster.name
}
resource "aws_iam_role_policy_attachment" "app-eks-cluster-AmazonEKSWorkerNodePolicy" {
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.app-eks-cluster.name
}
resource "aws_iam_role_policy_attachment" "app-eks-cluster-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "${local.policy_arn_prefix}/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.app-eks-cluster.name
}
*/