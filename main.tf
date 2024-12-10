provider "aws" {
  region = "us-east-2"  # Set to us-east-2
}

resource "aws_s3_bucket" "static_website" {
  bucket = "terraformross"  # Your specified bucket name
  acl    = "private"  # Keep the bucket private

  website {
    index_document = "index.html"
    error_document = "error.html"  # Optional: specify an error document
  }
}

resource "aws_s3_bucket_object" "index" {
  bucket = aws_s3_bucket.static_website.bucket
  key    = "index.html"
  source = "index.html"  # Path to your index.html file
}

resource "aws_s3_bucket_object" "error" {
  bucket = aws_s3_bucket.static_website.bucket
  key    = "error.html"  # Optional: specify an error document
  source = "path/to/your/error.html"  # Change to the path of your error.html file if you have one
}

resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = aws_s3_bucket.static_website.bucket_regional_domain_name
    origin_id   = "S3Origin"

    # Restrict access to the S3 bucket
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cdn.iam_arn
    }
  }

  enabled             = true
  default_root_object = "index.html"

  # Cache behavior
  default_cache_behavior {
    target_origin_id = "S3Origin"

    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    # Set the TTL values as needed
    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000
  }

  # Viewer settings
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # Optional: Set the price class
  price_class = "PriceClass_All"

  # Optional: Set the comment
  comment = "CloudFront distribution for terraformross bucket"
}

resource "aws_cloudfront_origin_access_identity" "cdn" {
  comment = "Origin Access Identity for S3 bucket"
}

output "cloudfront_url" {
  value = aws_cloudfront_distribution.cdn.domain_name
}
