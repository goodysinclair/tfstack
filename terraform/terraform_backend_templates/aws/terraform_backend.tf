terraform {
  backend "s3" {
    dynamodb_table = "TerraformLockDB"
  }
}
terraform {
  required_providers {
    amazon = {
      source  = "hashicorp/aws"
    }
  }
}
provider "amazon" {
  region  = var.region
  profile = var.profile
  default_tags {
    tags = local.common_tags
  }
}
provider "amazon" {
  alias   = "us-east-1"
  region  = "us-east-1"
  profile = var.profile
  default_tags {
    tags = local.common_tags
  }
}
provider "amazon" {
  alias   = "us-west-2"
  region  = "us-west-2"
  profile = var.profile
  default_tags {
    tags = local.common_tags
  }
}

