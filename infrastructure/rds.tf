resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?" # Avoid chars that break CLI strings
}

resource "aws_db_instance" "postgres" {
  identifier = var.rds_config.identifier

  engine         = var.rds_config.engine
  engine_version = var.rds_config.engine_version
  instance_class = var.rds_config.instance_class

  allocated_storage     = var.rds_config.allocated_storage
  max_allocated_storage = var.rds_config.max_allocated_storage
  storage_type          = var.rds_config.storage_type

  db_name  = var.rds_config.db_name
  username = var.rds_config.username
  password = random_password.db_password.result

  db_subnet_group_name   = aws_db_subnet_group.default_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_public.id]

  publicly_accessible = var.rds_config.publicly_accessible
  multi_az            = var.rds_config.multi_az

  backup_retention_period = var.rds_config.backup_retention_period
  skip_final_snapshot     = var.rds_config.skip_final_snapshot
  deletion_protection     = var.rds_config.deletion_protection

  auto_minor_version_upgrade = var.rds_config.auto_minor_version_upgrade

  tags = {
    Name = var.rds_config.identifier
  }
}