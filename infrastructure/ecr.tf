resource "aws_ecr_repository" "transaction_system" {
  name                 = var.ecr_config.name
  image_tag_mutability = var.ecr_config.tag_mutable
  force_delete         = var.ecr_config.force_delete
  image_scanning_configuration {
    scan_on_push = var.ecr_config.scan_on_push
  }
}

