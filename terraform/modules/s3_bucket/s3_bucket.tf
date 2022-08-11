resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  acl    = "private"
  versioning {
    enabled = var.versioning
  }
  tags = {
    Name = var.bucket_name
  }
}

