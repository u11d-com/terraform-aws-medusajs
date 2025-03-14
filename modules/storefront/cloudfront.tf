locals {
  origin_id = "${local.prefix}-storefront-alb"
}

resource "aws_cloudfront_vpc_origin" "main" {
  vpc_origin_endpoint_config {
    name                   = local.origin_id
    arn                    = aws_lb.main.arn
    http_port              = 80
    https_port             = 443
    origin_protocol_policy = "http-only"

    origin_ssl_protocols {
      quantity = 1
      items    = ["TLSv1.2"]
    }
  }

  tags = local.tags
}

resource "aws_cloudfront_distribution" "main" {
  enabled = true
  comment = title(local.prefix)

  origin {
    domain_name = aws_lb.main.dns_name
    origin_id   = local.origin_id

    vpc_origin_config {
      vpc_origin_id = aws_cloudfront_vpc_origin.main.id
    }
  }

  price_class = var.cloudfront_price_class

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  default_cache_behavior {
    target_origin_id       = local.origin_id
    viewer_protocol_policy = "redirect-to-https"

    // Inline configuration because separate cache policy can't be configured
    // to pass cookies without cache:
    // operation error CloudFront: CreateCachePolicy, https response error StatusCode: 400,
    // InvalidArgument: The parameter HeaderBehavior is invalid for policy with caching disabled.
    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0

    forwarded_values {
      query_string = true
      headers      = ["*"]

      cookies {
        forward = "all"
      }
    }

    allowed_methods = ["GET", "HEAD", "POST", "PUT", "PATCH", "OPTIONS", "DELETE"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]
  }

  tags = local.tags
}
