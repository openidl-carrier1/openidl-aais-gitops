resource "aws_iam_user" "baf_automation" {
  name = "${local.std_name}-baf-automation"
  force_destroy = true
  tags = merge(local.tags, { Name = "${local.std_name}-baf-automation", Node_type = var.node_type })
}
resource "aws_iam_access_key" "baf_automation_access_key" {
  user = aws_iam_user.baf_automation.name
  status = "Active"
}
resource "aws_iam_user_policy_attachment" "baf_automation_policy_attach" {
  user       = aws_iam_user.baf_automation.name
  policy_arn = aws_iam_policy.eks_admin_policy.arn
}

