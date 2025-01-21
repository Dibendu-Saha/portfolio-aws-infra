# Create S3 bucket for the file
resource "aws_s3_bucket" "bucket" {
  bucket = "portfolio-v2-resources"
}

# Allow public access for the file
resource "aws_s3_bucket_public_access_block" "access" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Create bucket policy
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id

  # Make sure to wait for the public access block to be applied first
  depends_on = [aws_s3_bucket_public_access_block.access]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowS3FileReadAccess"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.bucket.arn}/*"
        Condition = {
          ArnLike = {
            "aws:SourceArn" = var.downloadCv_lambda_arn
          }
        }
      }
    ]
  })
}