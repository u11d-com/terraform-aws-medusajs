locals {
  origin_id = "${local.prefix}-lb"
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

  timeouts {
    create = "30m"
  }

  depends_on = [aws_lb_target_group.main, aws_security_group.lb]

  tags = local.tags
}

resource "aws_cloudfront_function" "block_access" {
  count = var.expose_admin_only ? 1 : 0

  name    = "${local.prefix}-block-access"
  runtime = "cloudfront-js-1.0"
  code    = <<-EOT
    function handler(event) {
      return {
        statusCode: 403,
        statusDescription: 'Forbidden'
      }
    }
  EOT
}

resource "aws_cloudfront_distribution" "main" {
  enabled = true
  comment = title(local.prefix)

  aliases = var.custom_domains != null ? var.custom_domains : []

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
    acm_certificate_arn      = var.custom_domains != null ? var.acm_certificate_arn : null
    ssl_support_method       = var.custom_domains != null ? "sni-only" : null
    minimum_protocol_version = var.custom_domains != null ? "TLSv1.2_2021" : null

    cloudfront_default_certificate = var.custom_domains == null ? true : null
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

    allowed_methods = var.expose_admin_only ? ["GET", "HEAD"] : ["GET", "HEAD", "POST", "PUT", "PATCH", "OPTIONS", "DELETE"]
    cached_methods  = var.expose_admin_only ? ["GET", "HEAD"] : ["GET", "HEAD", "OPTIONS"]

    dynamic "function_association" {
      for_each = var.expose_admin_only ? [1] : []
      content {
        event_type   = "viewer-request"
        function_arn = aws_cloudfront_function.block_access[0].arn
      }
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.expose_admin_only ? [1] : []
    content {
      path_pattern           = "/admin/*"
      target_origin_id       = local.origin_id
      viewer_protocol_policy = "redirect-to-https"

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
  }

  tags = local.tags
}
