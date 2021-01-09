#!/usr/local/bin/python


import boto3
import os
import subprocess
import argparse

## configure python
session         = boto3.Session(region_name='us-east-1')
ec2_client      = session.client('ec2')

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
    parser.add_argument("--init", help="terraform init") 
    parser.add_argument("--plan", help="terraform plan") 
    parser.add_argument("--apply", help="terraform apply") 
    parser.add_argument("--destroy", help="terraform destroy") 
    parser.add_argument("--import", help="terraform import") 
    parser.add_argument("-irm",
                        "--initialize-root-module",
                        help="initialize root module") 
    parser.add_argument("-ipa", "--init-plan-apply",
                        help="terraform init, plan and apply") 
    parser.add_argument("-lam", "--list-available-modules",
                        help="list available modules") 
    parser.add_argument("-am", "--add-module", help="add module") 
    parser.add_argument("-gwi", "--github-workflow-init",
                        help="create github workflow file") 
    parser.add_argument("--state-list",
                        help="terraform state list") 
    parser.add_argument("--status",
                        help="status based on state file") 
    parser.add_argument("--custom", help="run custom terraform commands") 
    parser.add_argument("-v", "--version", help="version") 
    args = parser.parse_args()
    if args.init == 'enable':
        init_bool = 'true'
    if args.plan == 'enable':
        plan_bool = 'true'
    if args.apply == 'enable':
        apply_bool = 'true'
    if args.destroy == 'enable':
        destroy_bool = 'true'
    if args.import == 'enable':
        import_bool = 'true'
    if args.initialize-root-module == 'enable':
        initialize-root-module_bool = 'true'
    if args.init-plan-apply == 'enable':
        ipa_bool = 'true'
    if args.list-available-modules == 'enable':
        lam_bool = 'true'
    if args.add_module == 'enable':
        am_bool = 'true'
    if args.github-workflow-file == 'enable':
        gwi_bool = 'true'
    if args. == 'enable':
        _bool = 'true'
    if args. == 'enable':
        _bool = 'true'
    if args. == 'enable':
        _bool = 'true'
    if args. == 'enable':
        _bool = 'true'





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
    write_root_module_files()

if __name__ == "__main__":
    main()



