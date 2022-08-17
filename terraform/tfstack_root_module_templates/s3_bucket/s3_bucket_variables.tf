variable "bucket_names" {
  description = "Bucket names per region. A good convention is <product>-<env>-<region>"
  default = {
    goody-us-east-1 = "EXAMPLE_bucket_name-dev-us-east-1"
    qa-us-west-2    = "EXAMPLE_bucket_name-qa-us-west-2"
    prod-us-east-1  = "EXAMPLE_bucket_name-prod-us-east-1"
  }
}
variable "versioning" {
  default     = "true"
  description = "true or false"
}
locals {
  bucket_name = lookup(var.bucket_names, "${var.environment}-${var.region}")
}

