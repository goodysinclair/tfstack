variable "bucket_names" {
  description = "Bucket names per region, leave blank if not needed"
  default = {
    sis-us-east-1        = ""
    shs-us-east-1        = ""
    dev-us-east-1        = ""
    qa-us-east-1         = ""
    production-us-east-1 = ""
    uccdev-us-east-1     = ""
    uccqa-us-east-1      = ""
    uccprod-us-east-1    = ""
  }
}
variable "versioning" {
  default = "true"
  description = "true or false"
}
locals {
  bucket_name = lookup(var.bucket_names, "${var.environment}-${var.region}")
}

