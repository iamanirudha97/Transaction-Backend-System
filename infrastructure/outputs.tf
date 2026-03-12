output "rds_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "rds_address" {
  value = aws_db_instance.postgres.address
}

output "rds_port" {
  value = aws_db_instance.postgres.port
}

output "security_group_id" {
  value = aws_security_group.rds_public.id
}

output "database_password" {
  value     = random_password.db_password.result
  sensitive = true
}

output "github_actions_role_arn" {
  value = aws_iam_role.github_oidc_role.arn
}

output "app_env_secret_arn" {
  value       = aws_secretsmanager_secret.app_env.arn
  description = "ARN of the Secrets Manager secret containing app env (DB_SOURCE, SERVER_ADDRESS, etc.)"
}

output "app_env_secret_name" {
  value       = aws_secretsmanager_secret.app_env.name
  sensitive   = true
  description = "Name of the Secrets Manager secret for app env"
}