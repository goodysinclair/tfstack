variable "bucket_names" {
  description = "Bucket names per region. A good convention is <product>-<env>-<region>"
  default = {
    goody-us-east-1 = "EXAMPLE_unique_bucket_name-goody--us-east-1"
    goody-us-west-2 = "EXAMPLE_unique_bucket_name-goody--us-west-2"
    qa-us-east-1    = "EXAMPLE_unique_bucket_name-qa--us-east-1"
    qa-us-west-2    = "EXAMPLE_unique_bucket_name-qa--us-west-2"
    prod-us-east-1  = "EXAMPLE_unique_bucket_name-prod--us-east-1"
    prod-us-west-2  = "EXAMPLE_unique_bucket_name-prod--us-west-2"
  }
}
variable "versioning" {
  default     = "true"
  description = "true or false"
}
locals {
  bucket_name = lookup(var.bucket_names, "${var.environment}-${var.region}")
}

