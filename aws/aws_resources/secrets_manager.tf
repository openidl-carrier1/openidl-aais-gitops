#generating random string for vault credentials to set in secret manager
resource "random_password" "vault_password" {
  length = 12
  special = true
  upper = true
  number = true
  lower = true
  override_special = "@#$%&*-_+:?!"
  keepers = {
    reset = var.vault_password_reset
  }
}
#setting up vault secret in secret manager
resource "aws_secretsmanager_secret" "vault_secret" {
  name = "${var.aws_env}-${var.org_name}-vaultssecret" #rename this to vault
  description = "vault credentials for ${var.org_name} node"
  policy = <<POLICY
  {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": ["${var.aws_role_arn}", "${aws_iam_user.git_actions_user.arn}"]
      },
      "Action": "secretsmanager:GetSecretValue",
      "Resource": "*"
    }]
  }
  POLICY
  recovery_window_in_days = 7
  tags = merge(local.tags, { Name = "${var.aws_env}-${var.org_name}-vault", Cluster_type = "both" })
}
#setting up vault secret in secret manager
resource "aws_secretsmanager_secret_version" "vault_secret_version" {
  secret_id = aws_secretsmanager_secret.vault_secret.id
  secret_string = var.aws_env == "prod" ? jsonencode(local.vault_secrets_set_prod) : jsonencode(local.vault_secrets_set_non_prod)
}
