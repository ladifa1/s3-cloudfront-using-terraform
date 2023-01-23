# create S3 Bucket for network:
resource "aws_s3_bucket" "network" {
  bucket = var.bucket_network

  tags = {
    "ManagedBy" = "Terraform"
  }

  force_destroy = true
}

# create bucket ACL for network  :
resource "aws_s3_bucket_acl" "network_acl" {
  bucket = aws_s3_bucket.network.id
  acl    = "private"
}

# AWS recommends that you wait for 15 minutes after enabling versioning before issuing write operations (PUT or DELETE) on objects in the bucket.
resource "aws_s3_bucket_versioning" "versioning_network" {
  bucket = aws_s3_bucket.network.id
  versioning_configuration {
    status = "Enabled"
  }
}

# block public access to network bucket :
resource "aws_s3_bucket_public_access_block" "public_block_network" {
  bucket = aws_s3_bucket.network.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

# encrypt bucket using SSE-S3 to network bucket :
resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt_network" {
  bucket = aws_s3_bucket.network.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# create S3 website hosting for network:
resource "aws_s3_bucket_website_configuration" "website_network" {
  bucket = aws_s3_bucket.network.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

# add bucket policy to let the CloudFront OAI get objects:
resource "aws_s3_bucket_policy" "bucket_policy_network" {
  bucket = aws_s3_bucket.network.id
  policy = data.aws_iam_policy_document.bucket_policy_document.json
}

data "aws_s3_bucket" "bucket_network" {
  bucket = var.bucket_network
}
