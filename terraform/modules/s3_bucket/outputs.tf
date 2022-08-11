output "bucket_name" {
  value = aws_s3_bucket.bucket.id
}
output "bucket_id" {
  value = aws_s3_bucket.bucket.id
}
output "bucket_arn" {
  value = aws_s3_bucket.bucket.arn
}
output "bucket_acl" {
  value = aws_s3_bucket.bucket.acl
}
output "bucket_acceleration_status" {
  value = aws_s3_bucket.bucket.acceleration_status
}
output "bucket_domain_name" {
  value = aws_s3_bucket.bucket.bucket_domain_name
}
output "bucket_regional_domain_name" {
  value = aws_s3_bucket.bucket.bucket_regional_domain_name
}
output "bucket_cors_rule" {
  value = aws_s3_bucket.bucket.cors_rule
}
output "bucket_grant" {
  value = aws_s3_bucket.bucket.grant
}
output "bucket_hosted_zone_id" {
  value = aws_s3_bucket.bucket.hosted_zone_id
}
output "bucket_lifecycle_rule" {
  value = aws_s3_bucket.bucket.lifecycle_rule
}
output "bucket_logging" {
  value = aws_s3_bucket.bucket.logging
}
output "bucket_object_lock_configuration" {
  value = aws_s3_bucket.bucket.object_lock_configuration
}
output "bucket_policy" {
  value = aws_s3_bucket.bucket.policy
}
output "bucket_region" {
  value = aws_s3_bucket.bucket.region
}
output "bucket_replication_configuration" {
  value = aws_s3_bucket.bucket.replication_configuration
}
output "bucket_request_payer" {
  value = aws_s3_bucket.bucket.request_payer
}
output "bucket_server_side_encryption_configuration" {
  value = aws_s3_bucket.bucket.server_side_encryption_configuration
}
output "bucket_tags_all" {
  value = aws_s3_bucket.bucket.tags_all
}
output "bucket_versioning" {
  value = aws_s3_bucket.bucket.versioning
}
output "bucket_website" {
  value = aws_s3_bucket.bucket.website
}
output "bucket_website_endpoint" {
  value = aws_s3_bucket.bucket.website_endpoint
}
output "bucket_website_domain" {
  value = aws_s3_bucket.bucket.website_domain
}

