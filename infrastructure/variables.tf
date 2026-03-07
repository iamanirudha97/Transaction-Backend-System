variable "aws_region" {
  type        = string
  description = "AWS region to deploy into"
  default     = "us-east-1"
}

variable "ecr_config" {
type = object({
    name = string
    tag_mutable = string
    force_delete = bool
    scan_on_push = bool
  }) 
  description = "AWS ECR Config"
}

variable "oidc_config" {
  type = object({
    role_name  = string
    repo       = string
    repo_ref   = string
    policy_arn = string
  })
  description = "OIDC config for GitHub Actions: IAM role name, repo (owner/repo), ref (e.g. ref:refs/heads/main), and ECR policy ARN"
}