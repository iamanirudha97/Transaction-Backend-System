resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?" # Avoid chars that break CLI strings
}

resource "aws_db_instance" "postgres" {
  identifier = "free-tier-postgres-public"

  engine         = "postgres"
  engine_version = "16.3"
  instance_class = "db.t3.micro"

  allocated_storage     = 20
  max_allocated_storage = 20
  storage_type          = "gp2"

  db_name  = "simple_bank"
  username = "root"
  password = random_password.db_password.result

  db_subnet_group_name   = aws_db_subnet_group.default_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_public.id]

  publicly_accessible = true
  multi_az            = false

  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false

  auto_minor_version_upgrade = true

  tags = {
    Name = "free-tier-postgres-public"
  }
}

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