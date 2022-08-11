resource "aws_s3_bucket_ownership_controls" "disable_s3_acl" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

