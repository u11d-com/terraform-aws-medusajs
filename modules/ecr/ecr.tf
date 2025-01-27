resource "aws_ecr_repository" "main" {
  name         = "${local.prefix}-${var.name}"
  force_delete = true

  tags = local.tags
}

resource "aws_ecr_lifecycle_policy" "main" {
  count = var.retention_count != null ? 1 : 0

  repository = aws_ecr_repository.main.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last ${var.retention_count} images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = var.retention_count
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
