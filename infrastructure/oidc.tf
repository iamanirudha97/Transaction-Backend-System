resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

resource "aws_iam_role" "github_oidc_role" {
  name = var.oidc_config.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity",
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        },
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" : "repo:${var.oidc_config.repo}:${var.oidc_config.repo_ref}"
          }
        }
      }
    ]
  })
}

# 3. Attach ECR permissions
resource "aws_iam_role_policy_attachment" "ecr_attach" {
  role       = aws_iam_role.github_oidc_role.name
  policy_arn = var.oidc_config.policy_arn
}