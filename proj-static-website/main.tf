terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.32.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# Generate random suffix
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Create S3 bucket
resource "aws_s3_bucket" "mystatic_website" {
  bucket = "mystatic-website-${random_id.bucket_suffix.hex}"
}

# Disable public access block
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.mystatic_website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Enable Static Website Hosting
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.mystatic_website.id

  index_document {
    suffix = "index.html"
  }
}

# Bucket policy to allow public read
resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.mystatic_website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action   = ["s3:GetObject"]
        Resource = "${aws_s3_bucket.mystatic_website.arn}/*"
      }
    ]
  })
}

# Upload index.html
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.mystatic_website.bucket
  key          = "index.html"
  source       = "./index.html"
  content_type = "text/html"

  depends_on = [
    aws_s3_bucket_public_access_block.public_access,
    aws_s3_bucket_policy.public_read
  ]
}

# Output website URL
output "website_url" {
  value = aws_s3_bucket_website_configuration.website.website_endpoint
}
