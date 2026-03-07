resource "aws_ecr_repository" "transaction_system" {
  name                 = "transaction-system"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

