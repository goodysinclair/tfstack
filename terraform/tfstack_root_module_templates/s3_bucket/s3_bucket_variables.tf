variable "bucket_names" {
  description = "Bucket names per region. A good convention is <product>-<env>-<region>"
  default = {
    dev-us-east-1  = "EXAMPLE_unique_dev_bucket_name-us-east-1"
    dev-us-west-2  = "EXAMPLE_unique_dev_bucket_name-us-west-2"
    qa-us-east-1   = "EXAMPLE_unique_qa_bucket_name-us-east-1"
    qa-us-west-2   = "EXAMPLE_unique_qa_bucket_name-us-west-2"
    prod-us-east-1 = "EXAMPLE_unique_prod_bucket_name-us-east-1"
    prod-us-west-2 = "EXAMPLE_unique_prod_bucket_name-us-west-2"
  }
}
variable "versioning" {
  default = "true"
  description = "true or false"
}
locals {
  bucket_name = lookup(var.bucket_names, "${var.environment}-${var.region}")
}

