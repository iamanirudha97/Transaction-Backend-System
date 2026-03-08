
resource "aws_security_group" "rds_public" {
  name   = "rds-public-postgres-sg"
  vpc_id = aws_default_vpc.default.id

  ingress {
    description = "PostgreSQL access"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["66.30.245.51/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}