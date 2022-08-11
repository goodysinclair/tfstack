variable "instance_name" {}
variable "instance_type" {}
variable "key_name" {}
variable "ami_id" {}
variable "subnet_id" {}
variable "vpc_security_group_ids" {}
variable "userdata_file" {}
variable "root_volume_size" {}
variable "assume_role_policy" {}
variable "policy" {}
variable "managed_policy_arn_list" {}
variable "timezone" { default = "New_York" }
variable "environment" {}
variable "region" {}
variable "common_tags" {}

