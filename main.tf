terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80"
    }
  }
}

provider "aws" {
  region = "us-east-2"  # Set to us-east-2
}

resource "aws_s3_bucket" "static_website" {
  bucket = "terraross2"
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.static_website.bucket
  key    = "index.html"
  source = "index.html"
}

resource "aws_cloudfront_origin_access_identity" "cdn" {
  comment = "Origin Access Identity for S3 bucket"
}

resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket.static_website.bucket_regional_domain_name
    origin_id   = "S3Origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cdn.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    target_origin_id       = "S3Origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"  # Change this if you want to restrict access by geography
    }
  }

  price_class = "PriceClass_All"

  comment = "CloudFront distribution for my-unique-bucket-name-12345 bucket"
}

output "cloudfront_url" {
  value = aws_cloudfront_distribution.cdn.domain_name
}
