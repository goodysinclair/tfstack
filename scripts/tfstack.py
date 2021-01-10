#!/usr/local/bin/python


import boto3
#import os
#import subprocess
import argparse

## configure python
session         = boto3.Session(region_name='us-east-1')
ec2_client      = session.client('ec2')

#---------------------------------------------------------
#                  GLOBAL_VARIABLES
#---------------------------------------------------------

init_bool    = 'false'
plan_bool    = 'false'
apply_bool   = 'false'
destroy_bool = 'false'
import_bool  = 'false'
irm_bool     = 'false'
ipa_bool     = 'false'
aa_bool      = 'false'
lam_bool     = 'false'
am_bool      = 'false'
gwi_bool     = 'false'
state_bool   = 'false'
status_bool  = 'false'
custom_bool  = 'false'
version_bool = 'false'

#---------------------------------------------------------
#                  TEXT_BLOCKS
#---------------------------------------------------------

terraform_backend_text = """
terraform {
  backend "s3" {
    dynamodb_table = "TerraformLockDB"
  }
}

terraform {
  required_providers {
    amazon = {
      source  = "hashicorp/aws"
      version = ">= 2.0"
    }
  }
}
provider "amazon" {
  region  = var.region
  profile = var.profile
}
provider "amazon" {
  alias   = "us-east-1"
  region  = "us-east-1"
  profile = var.profile
}
provider "amazon" {
  alias   = "us-west-2"
  region  = "us-west-2"
  profile = var.profile
}
"""

terraform_standard_variables_text = """
variable "application" {}
variable "owner" {}
variable "product" {}
variable "profile" {}
variable "environment" {}
variable "region" {}
variable "management_method" {}
variable "git_repo_name" {}
variable "git_repo_path" {}

locals {
  common_tags = {
    Region           = var.region
    Environment      = var.environment
    Application      = var.application
    Owner            = var.owner
    Product          = var.product
    ManagementMethod = var.management_method
    GitRepoName      = var.git_repo_name
    GitRepoPath      = var.git_repo_path
  }
}
"""

all_resources_text = """
owner       = "EXAMPLE_email"
product     = "EXAMPLE_product"
application = "EXAMPLE_application"
"""

gitignore_text = """
**/.terraform*
tfplan*
"""

#---------------------------------------------------------
#                 INPUT_FUNCTIONS / ARG_PARSE
#---------------------------------------------------------

def arg_parse():
    parser = argparse.ArgumentParser()
    parser.add_argument("-init", 
                        "--terraform-init",
                        metavar='tfvars_file',
                        type=argparse.FileType('r'),
                        help="runs terraform init") 
    parser.add_argument("-plan",
                        "--terraform-plan",
                        metavar='tfvars_file',
                        type=argparse.FileType('r'),
                        help="runs terraform plan") 
    parser.add_argument("-apply",
                        "--terraform-apply",
                        metavar='tfvars_file',
                        type=argparse.FileType('r'),
                        help="runs terraform apply") 
    parser.add_argument("-ipa", "--init-plan-apply",
                        metavar='tfvars_file',
                        type=argparse.FileType('r'),
                        help="runs terraform init, plan and apply") 
    parser.add_argument("-destroy",
                        "--terraform-destroy",
                        metavar='tfvars_file',
                        type=argparse.FileType('r'),
                        help="runs terraform destroy") 
    parser.add_argument("-import",
                        "--terraform-import",
                        metavar='tfvars_file',
                        help="terraform import") 
    parser.add_argument("-irm",
                        "--initialize-root-module",
                        action='store_true',
                        help="initialize root module") 
    parser.add_argument("-aa", "--auto-approve",
                        action='store_true',
                        help="use with -ipa or --apply") 
    parser.add_argument("-lam", "--list-available-modules",
                        action='store_true',
                        help="list available modules") 
    parser.add_argument("-am", "--add-module",
                        metavar='module_name',
                        help="add a module") 
    parser.add_argument("-gwi", "--github-workflow-file",
                        metavar='tfvars_file',
                        help="create github workflow file") 
    parser.add_argument("-state",
                        "--terraform-state-list",
                        metavar='tfvars_file',
                        help="terraform state list") 
    parser.add_argument("--status",
                        metavar='tfvars_file',
                        help="status based on state file") 
    parser.add_argument("--custom",
                        metavar='custom_action',
                        help="run custom terraform commands") 
    parser.add_argument("--verbose",
                        action='store_true',
                        help="enable more messages") 
    parser.add_argument("-v", "--version",
                        action='store_true',
                        help="version") 
    args = parser.parse_args()
    return args.terraform_init,
    args.terraform_plan,
    args.terraform_apply,
    args.terraform_destroy,
    args.terraform_import,
    args.initialize_root_module,
    args.init_plan_apply,
    args.list_available_modules,
    args.add_module,
    args.github_workflow_file,
    args.terraform_state_list,
    args.status,
    args.custom,
    args.version
    print("Arguments! ", args)






def spacer():
    print("=======================================================================\n")

#def verbose_check():
#def custom_arguments():
#def verify_aws_profile_exists():
#def verify_no_examples():
#def set_module_variables():
#def set_git_variables():
#def verify_initialization(){:
#def verify_env_tfvars_file(){:
#def set_env_tfvars_file_variables():
#def set_common_tfvars_file_variables():
#def verify_common_tfvars_file_values(){:
#def set_aws_variables():
#def display_variables():
#def terraform_validate():
#def github_workflow_file():
#def check_uncommitted():
#def postapply_message():
#def terraform_init():
#def terraform_plan():
#def terraform_import():
#def terraform_apply():
#def terraform_state_list():
#def terraform_destroy():
#def terraform_ipa():
#def tag_remote_state_file():


def write_root_module_files():
    print("write_root_module_files")
    return 'none'
    try:
        file = open('terraform_backend.tf', "r")
    except:
        file = open('terraform_backend.tf', "w+")
        file.write(terraform_backend_text)
    try:
        file = open('terraform_standard_variables.tf', "r")
    except:
        file = open('terraform_standard_variables.tf', "w+")
        file.write(terraform_standard_variables_text)
    try:
        file = open('all_resources_common_variables.tf', "r")
    except:
        file = open('all_resources_common_variables.tf', "w+")
        file.write(all_resources_text)
    try:
        file = open('.gitignore', "r")
    except:
        file = open('.gitignore', "w+")
        file.write(gitignore_text)


#def clone_templates_repository():
#def set_templates_repository_branch():
#def set_templates_repository_version_tag():
#def list_available_modules():
#def add_module():
#def prereqs_terraform():
#def prereqs_module():
#def usage_short():
#def display_readme():
#def get_terraform_resource_status():


def main():
    arg_parse()

    if irm_bool == "enable":
        write_root_module_files()


if __name__ == "__main__":
    main()



