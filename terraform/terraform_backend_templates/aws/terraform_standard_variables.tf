##############################
# populate Owner and Product #
##############################

variable "owner" {
  default     = "EXAMPLE_your_email_address"
  description = "Use your email address"
}
variable "product" {
  default     = "EXAMPLE_product"
  description = "Choose a correct one from the Published Standards"
}

##########################
# no more edits required #
##########################

variable "profile" {
  description = "Set by tfstack"
}
variable "environment" {
  description = "Set by tfstack"
}
variable "region" {
  description = "Set by tfstack"
}
variable "management_method" {
  description = "Set by tfstack"
}
variable "git_repo_name" {
  description = "Set by tfstack"
}
variable "git_repo_path" {
  description = "Set by tfstack"
}

locals {
  common_tags = {
    Name             = "${var.git_repo_name}-NAME-NOT-PROVIDED-BY-OWNER"
    Region           = var.region
    Environment      = var.environment
    Owner            = var.owner
    Product          = var.product
    ManagementMethod = var.management_method
    GitRepoName      = var.git_repo_name
    GitRepoPath      = var.git_repo_path
  }
}

