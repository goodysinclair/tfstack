variable "bucket_name" {}
variable "versioning" {}
variable "environment" {}
variable "region" {}

variable "block_public_acls" {
  default = "true"
}
variable "block_public_policy" {
  default = "true"
}
variable "ignore_public_acls" {
  default = "true"
}
variable "restrict_public_buckets" {
  default = "true"
}

