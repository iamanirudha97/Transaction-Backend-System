locals {
  app_env_secret_value = jsonencode({
    DB_DRIVER             = "postgres"
    DB_SOURCE             = "postgresql://${var.rds_config.username}:${random_password.db_password.result}@${aws_db_instance.postgres.address}:${aws_db_instance.postgres.port}/${var.rds_config.db_name}?sslmode=disable"
    SERVER_ADDRESS        = var.app_secret_config.server_address
    TOKEN_SYMMETRIC_KEY   = var.app_secret_config.token_symmetric_key
    ACCESS_TOKEN_DURATION = var.app_secret_config.access_token_duration
  })
}

resource "aws_secretsmanager_secret" "app_env" {
  name        = var.app_secret_config.secret_name
  description = "App environment variables (DB connection, server, token config)"
}

resource "aws_secretsmanager_secret_version" "app_env" {
  secret_id     = aws_secretsmanager_secret.app_env.id
  secret_string = local.app_env_secret_value

  depends_on = [aws_db_instance.postgres, random_password.db_password]
}
