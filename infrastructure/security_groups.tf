resource "aws_security_group" "rds_public" {
  name   = var.rds_security_group_config.name
  vpc_id = aws_default_vpc.default.id

  ingress {
    description = "PostgreSQL access"
    from_port   = var.rds_security_group_config.ingress_port
    to_port     = var.rds_security_group_config.ingress_port
    protocol    = "tcp"
    cidr_blocks = var.rds_security_group_config.allowed_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}