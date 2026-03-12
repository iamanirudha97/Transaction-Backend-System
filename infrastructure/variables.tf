variable "aws_region" {
  type        = string
  description = "AWS region to deploy into"
  default     = "us-east-1"
}

variable "ecr_config" {
  type = object({
    name         = string
    tag_mutable  = string
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

variable "rds_security_group_config" {
  type = object({
    name          = string
    ingress_port  = number
    allowed_cidrs = list(string)
  })
  description = "Security group config for RDS: name, ingress port (e.g. 5432), and allowed CIDR blocks"
}

variable "rds_config" {
  type = object({
    identifier                 = string
    engine                     = string
    engine_version             = string
    instance_class             = string
    allocated_storage          = number
    max_allocated_storage      = number
    storage_type               = string
    db_name                    = string
    username                   = string
    publicly_accessible        = bool
    multi_az                   = bool
    backup_retention_period    = number
    skip_final_snapshot        = bool
    deletion_protection        = bool
    auto_minor_version_upgrade = bool
  })
  description = "RDS instance config: identifier, engine, storage, db_name, and operational flags"
}

variable "app_secret_config" {
  type = object({
    secret_name           = string
    server_address        = string
    token_symmetric_key   = string
    access_token_duration = string
  })
  description = "Secrets Manager secret name and app env values (SERVER_ADDRESS, TOKEN_SYMMETRIC_KEY, ACCESS_TOKEN_DURATION)"
  sensitive   = true
}