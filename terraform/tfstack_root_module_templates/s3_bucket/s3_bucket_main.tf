module "s3_bucket" {
  source = "git@github.com:goodysinclair/tfstack.git//terraform/modules/s3_bucket?ref=[module_version_tag]"

  bucket_name = local.bucket_name
  versioning  = var.versioning
  environment = var.environment
  region      = var.region
}

