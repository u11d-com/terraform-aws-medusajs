resource "aws_s3_bucket" "uploads" {
  bucket_prefix = "${local.prefix}-uploads-"

  tags = local.tags
}

resource "aws_s3_bucket_public_access_block" "uploads" {
  bucket = aws_s3_bucket.uploads.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

data "aws_iam_policy_document" "allow_public_read" {
  statement {
    sid    = "PublicRead"
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.uploads.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "allow_public_read" {
  bucket = aws_s3_bucket.uploads.id
  policy = data.aws_iam_policy_document.allow_public_read.json
}

resource "aws_s3_bucket_cors_configuration" "uploads" {
  bucket = aws_s3_bucket.uploads.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "DELETE"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag", "Content-Length", "Content-Type"]
    max_age_seconds = 3000
  }
}
