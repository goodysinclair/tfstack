#!/bin/sh

tfstack_version='v0.44.1'
management_method=tfstack-${tfstack_version}

##todo:
 #deal with a repo with zero commits
 #add terraform import function?

spacer() {
  echo "======================================================================="
}

verbose_check() {
  verbose="false"
  echo $@ | grep -q "\-\-verbose" \
    && verbose="true"
}
  
verify_aws_profile_exists() {
  grep -q ${profile} ~/.aws/credentials \
    || { echo "Profile ${profile} does not exist, please check your aws credentials file." \
    && exit 1 ; }
}

verify_no_examples() {
  [[ "${verbose}" == "true" ]] \
    && spacer \
    && echo "Verifying all EXAMPLE values have been replaced ..."

  local ex_files
  local count=0
  for i in $(ls | grep -v README) ; do \
    grep --directories=skip -q EXAMPLE $i \
      && ((count=count+1)) \
      && ex_files="${ex_files}\n $i   <-- Please modify this file. Replace EXAMPLE values with real values." ; \
  done

  [[ "count" -ge "1" ]] \
    && echo "EXAMPLE values were found:" \
    && echo "" \
    && echo "${ex_files}" | column -t \
    && { exit 1 ; }
}

set_module_variables() {
  [[ "${verbose}" == "true" ]] \
    && spacer \
    && echo "Setting the module variables ..."

  modules_repo_url="ADD TEMPLATES GIT REPO HERE"
  modules_repo_name="cicd-templates"
  clone_directory="/tmp/github_terraform_templates"
  clone_path="${clone_directory}/${modules_repo_name}"
  modules_path="${clone_path}/terraform/modules"
  modules_template_path="${clone_path}/terraform/tfstack_root_module_templates"
  github_workflows_path="${clone_path}/ci-cd-templates/github_workflow_templates"
  github_workflow_file="github_workflow_template.yaml"
}

set_git_variables() {
  [[ "${verbose}" == "true" ]] \
    && spacer \
    && echo "Setting git variables ..."

  ##verify we are in a git repo first
  [[ $(git status | grep branch ) ]] \
    || { echo "Not in a git repository" && exit 1 ; }

  git_repo_path=$(git rev-parse --show-prefix | sed 's/\/$//g')
  git_commit=$(git log -1 | grep -m 1 commit | cut -d\  -f 2)
  git_repo_branch=$(git status | head -n 1 | awk 'NF>1{print $NF}')
  git_repo_name=$(basename `git rev-parse --show-toplevel`)
  git_repo_root_folder=$(git rev-parse --show-toplevel)
}

verify_initialization(){
  [[ -f terraform_standard_variables.tf ]] \
    || { echo "Root module directory not initialized yet." \
    && exit 1 ; }
}

verify_env_tfvars_file(){
  [[ "${verbose}" == "true" ]] \
    && spacer \
    && echo "Verifying the env-region-tfvars file ..."

  local env

  [[ -f ${env_tfvars_file} ]] \
    || { echo "tfvars file '${env_tfvars_file}' does not exist" && exit 1 ; }

  echo ${env_tfvars_file} \
    | grep -q \.tfvars \
    || { echo "tfvars file does not end in .tfvars" && exit 1 ; }

  env=$(grep \^environment ${env_tfvars_file} \
        | cut -d\" -f 2)

  echo ${env_tfvars_file} \
    | grep -i -q ${env} \
    || { echo "tfvars file environment name does not match contents of file" \
      && exit 1 ; }
}

set_env_tfvars_file_variables() {
  environment=$(grep \^environment ${env_tfvars_file} | cut -d\" -f 2)
  environment_lc=$(echo ${environment} |  tr '[:upper:]' '[:lower:]')
  environment_uc=$(echo ${environment} |  tr '[:lower:]' '[:upper:]')
  profile=${environment_lc}
  region=$(grep \^region ${env_tfvars_file} | cut -d\" -f 2)
}

set_common_tfvars_file_variables() {
  [[ "${verbose}" == "true" ]] \
    && spacer \
    && echo "Setting common_tfvars_file variables ..."

  common_var_file=all_resources_common_variables.auto.tfvars

  ##run this separately:
  set_env_tfvars_file_variables $@

  ##for backwards-compatability
    [[ -f all_resources_common_variables.tfvars ]] \
      && { echo "Please rename all _common_variables.tfvars files to end in .auto.tfvars" \
      && exit 1 ; }

  owner=$(grep \^owner ${common_var_file} | cut -d\" -f 2)
  product=$(grep \^product ${common_var_file} | cut -d\" -f 2)
  application=$(grep \^application ${common_var_file} | cut -d\" -f 2)
  name=$(grep \^name ${common_var_file} | cut -d\" -f 2)
  plan_file=tfplan-${environment_lc}-${region}.out
}

verify_common_tfvars_file_values(){
  [[ "${verbose}" == "true" ]] \
    && spacer \
    && echo "Verifying the values in the tfvars files ..."

  [[ -n ${application} ]] || { echo "Value of \"application\" is null, please fix." && exit 1 ; }
  [[ -n ${product} ]]     || { echo "Value of \"product\" is null, please fix." && exit 1 ; }
  [[ -n ${environment} ]] || { echo "Value of \"environment\" is null, please fix." && exit 1 ; }
  [[ -n ${owner} ]]       || { echo "Value of \"owner\" is null, please fix." && exit 1 ; }
  [[ -n ${name} ]]        || { echo "Value of \"name\" is null, please fix." && exit 1 ; }
}

set_aws_variables() {
  [[ "${verbose}" == "true" ]] \
    && spacer \
    && echo "Setting aws variables ..."

  backend_key="${git_repo_name}/${git_repo_path}/terraform.tfstate"
  state_bucket=$(aws ssm get-parameter \
    --name "/infrastructure/terraform/state-bucket" \
    --profile ${profile} \
    --region ${region} \
    | grep Value \
    | cut -d\" -f 4)
}

display_variables() {
  spacer

  echo "Displaying variables ..."
  echo "plan_file: ${plan_file}"
  echo "git_repo_path: ${git_repo_path}"
  echo "requested_templates_branch: ${requested_templates_branch}"
  echo "git_commit: ${git_commit}"
  echo "git_repo_name: ${git_repo_name}"
  echo "git_repo_branch: ${git_repo_branch}"
  echo "profile: ${profile}"
  echo "environment: ${environment}"
  echo "region: ${region}"
  echo "owner: ${owner}"
  echo "product: ${product}"
  echo "application: ${application}"
  echo "management_method: ${management_method}"
  echo "state_bucket: ${state_bucket}"
  echo "backend_key: ${backend_key}"
  echo "common_var_file: ${common_var_file}"
  echo "env_tfvars_file: ${env_tfvars_file}"
  echo "action: $1"
}

terraform_validate() {
  terraform validate \
    || exit 1
}

github_workflow_file() {
  [[ "${verbose}" == "true" ]] \
    && spacer \
    && echo "Adding github workflow file ..."

  prereqs_module $@

  ##clone the templates repository
    clone_templates_repository

  ##assume master branch unless otherwise specified:
    requested_templates_branch=master
    [[ -n ${3} ]] && requested_templates_branch=${3}
    echo "requested_templates_branch: ${requested_templates_branch}"

  ##checkout the requested branch:
    set_templates_repository_branch ${requested_templates_branch}

  ##set the modules/templates version branch/tag:
    set_templates_repository_version_tag ${requested_templates_branch}

  ##some prework:
    env_tfvars_file=$2
    verify_env_tfvars_file $@
    set_env_tfvars_file_variables $@
    set_git_variables $@
    set_module_variables $@

  cwd=$(basename `pwd`)

  ##make the workflows directory if it doesn't exist:
    [[ -d ${git_repo_root_folder}/.github/workflows/ ]] \
      || mkdir -p ${git_repo_root_folder}/.github/workflows

  ##'copy' the workflow file with some substitutions:
    cat ${github_workflows_path}/${github_workflow_file} \
      | sed "s/TERRAFORM_ROOT_MODULE_DIRECTORY/${cwd}/g" \
      | sed "s/AWS_ENVIRONMENT/${environment_lc}/g" \
      | sed "s/AWS_REGION/${region}/g" \
      > ${git_repo_root_folder}/.github/workflows/${environment_lc}-${region}-${cwd}.yaml
}

check_uncommitted() {

  ##local variables:
    local unchecked_files=0
    local prod_env_check=0

  ##check for uncommitted files in the current directory:
    git status | grep -F ./ | grep -F -v ../ | grep -v tfplan \
      && unchecked_files=1

  ##check for environment containing the string 'prod':
    echo $environment | grep -i prod \
      && prod_env_check=1

  ##if trying to apply to a prod account with unchecked files, bail
   #nothing goes to prod which isn't checked into github 

    echo "unchecked_files: ${unchecked_files}"
    echo "prod_env_check: ${prod_env_check}"

    [[ ${unchecked_files} -eq "1" ]] \
      && [[ ${prod_env_check} -eq "1" ]] \
      && { echo "You have unchecked files. Check them into github before deploying to a production-class account." \
           && exit 1 ; }
}

postapply_message() {
  spacer 
  echo "Please commit and push your changes."
  echo ""
  echo "git add . ; git commit -m \"Apply of ${env_tfvars_file} is complete.\" ; git push"
  spacer
}

terraform_init() {
  [[ "${verbose}" == "true" ]] \
    && spacer \
    && echo "Running terraform init ..."

  prereqs_terraform $@

  echo "----- terraform init -------"
  terraform init \
    -input=false \
    -backend-config="bucket=${state_bucket}" \
    -backend-config="region=${region}" \
    -backend-config="profile=${profile}" \
    -backend-config="key=${backend_key}" \
    -reconfigure \
    -upgrade \
      || { echo "Terraform init failed." && exit 1 ; }
}

terraform_plan() {
  terraform_init $@

  terraform_validate

  [[ "${verbose}" == "true" ]] \
    && spacer \
    && echo "Running terraform plan ..."

  prereqs_terraform $@

  echo "----- terraform plan -------"
  terraform plan \
    -input=false \
    -var-file=${env_tfvars_file} \
    -var "management_method=${management_method}" \
    -var "git_repo_name=${git_repo_name}" \
    -var "git_repo_path=${git_repo_path}" \
    -var "profile=${profile}" \
    -out ${plan_file} 
}

terraform_apply() {
  terraform_init $@
  terraform_plan $@

  [[ "${verbose}" == "true" ]] \
    && spacer \
    && echo "Running terraform apply ..."

  prereqs_terraform $@
  #check_uncommitted $@

  echo "----- terraform apply -------"
  terraform apply ${plan_file} \
    && tf_resource_status="Applied" \
    && tag_remote_state_file $@ \
    && postapply_message $@
}

terraform_state_list() {
  terraform_init $@

  [[ "${verbose}" == "true" ]] \
    && spacer \
    && echo "Running terraform state list ..."

  prereqs_terraform $@

  echo "----- terraform state list -------"
  terraform state list 
#    -input=false \
#    -var-file=${env_tfvars_file} \
#    -var "management_method=${management_method}" \
#    -var "git_repo_name=${git_repo_name}" \
#    -var "git_repo_path=${git_repo_path}" \
#    -var "profile=${profile}" \
#    -out ${plan_file}
}

terraform_destroy() {
  terraform_init $@

  [[ "${verbose}" == "true" ]] \
    && spacer \
    && echo "Running terraform destroy ..."

  prereqs_terraform $@

  echo "----- terraform destroy -------"
  terraform destroy \
    -var-file=${env_tfvars_file} \
    -var "management_method=${management_method}" \
    -var "git_repo_name=${git_repo_name}" \
    -var "git_repo_path=${git_repo_path}" \
    -var "profile=${profile}" \
      && tf_resource_status="Destroyed" \
      && tag_remote_state_file $@
}

tag_remote_state_file() {
  spacer
  echo "Tagging the remote state file ..."

  aws s3api put-object-tagging \
    --bucket ${state_bucket} \
    --key ${backend_key} \
    --tagging '{"TagSet": [{ "Key": "TerraformResourceStatus", "Value": "'"$tf_resource_status"'" }, { "Key": "Environment", "Value": "'"$environment"'" }, { "Key": "GitCommit", "Value": "'"$git_commit"'" }, { "Key": "GitRepoBranch", "Value": "'"$git_repo_branch"'" }, { "Key": "GitRepoName", "Value": "'"$git_repo_name"'" }, { "Key": "Application", "Value": "'"$application"'" }, { "Key": "Product", "Value": "'"$product"'" }, { "Key": "Owner", "Value": "'"$owner"'" }, { "Key": "GitRepoPath", "Value": "'"$git_repo_path"'" }, { "Key": "ManagementMethod", "Value": "'"$management_method"'" } ]}' \
    --profile ${profile} \
    --region ${region}
}

write_terraform_backend_partial() {
  cat << EOF > terraform_backend_partial.tf
## DO NOT EDIT THIS FILE ##
terraform {
  backend "s3" {
    dynamodb_table = "TerraformLockDB"
  }
}

EOF

  basename terraform_backend_partial.tf
}

write_terraform_providers() {
  cat << EOF > terraform_providers.tf
## DO NOT EDIT THIS FILE ##
provider "aws" {
  region  = var.region
  profile = var.profile
  version = "~> 2.0"
}
provider "aws" {
  alias   = "us-east-1"
  region  = "us-east-1"
  profile = var.profile
  version = "~> 2.0"
}
provider "aws" {
  alias   = "us-west-2"
  region  = "us-west-2"
  profile = var.profile
  version = "~> 2.0"
}

EOF

  basename terraform_providers.tf
}

write_terraform_standard_variables() {
  cat << EOF > terraform_standard_variables.tf
## DO NOT EDIT THIS FILE
variable "application" {}
variable "owner" {}
variable "product" {}
variable "profile" {}
variable "environment" {}
variable "region" {}
variable "name" {}
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
    Name             = var.name
    ManagementMethod = var.management_method
    GitRepoName      = var.git_repo_name
    GitRepoPath      = var.git_repo_path
  }
}

EOF

  basename terraform_standard_variables.tf
}

write_all_resources_common_variables() {
  cat << EOF > all_resources_common_variables.auto.tfvars
/*
  replace Example values
  with real values
  These values will be applied
  to all the resources managed
  in this root module directory
*/
owner       = "EXAMPLE_email"
product     = "EXAMPLE_product"
application = "EXAMPLE_application"
name        = "EXAMPLE_name"

EOF

  basename all_resources_common_variables.auto.tfvars
}

write_dev_us_east_1_tfvars() {
  cat << EOF >> dev-us-east-1.tfvars
/*
  minimal environment/region tfvars file
  added modules will append the proper contents here
  if required
*/

environment = "dev"
region      = "us-east-1"

EOF

  basename dev-us-east-1.tfvars
}

verify_gitignore() {
  ##git ignore .terraform/:
    grep -q terraform .gitignore 2>/dev/null \
      || echo '**/.terraform/*' >> .gitignore 

  ##git ignore the tfplan files:
    grep -q tfplan .gitignore 2>/dev/null \
      || echo 'tfplan*.out' >> .gitignore 
}

initialize_root_module() {

  echo "Creating missing core files"
  echo ...

  [[ -f terraform_backend_partial.tf ]] \
    && echo "File already exists: terraform_backend_partial.tf" \
    ||  write_terraform_backend_partial

  [[ -f terraform_providers.tf ]] \
    && echo "File already exists: terraform_providers.tf" \
    ||  write_terraform_providers

  [[ -f ${common_var_file} ]] \
    && echo "File already exists: ${common_var_file}" \
    ||  write_all_resources_common_variables

  [[ -f terraform_standard_variables.tf ]] \
    && echo "File already exists: terraform_standard_variables.tf" \
    ||  write_terraform_standard_variables

  ##only append to this file if environment and region aren't there already:
    [[ -f dev-us-east-1.tfvars ]] \
      && \
        grep -q 'environment/region' dev-us-east-1.tfvars \
          || write_dev_us_east_1_tfvars

  verify_gitignore

  spacer

  exit 0
}

clone_templates_repository() {
  [[ "${verbose}" == "true" ]] \
    && spacer \
    && echo "Cloning the templates repo ..."

  ##delete the repo and clone it fresh each time to avoid issues:
    rm -rf ${clone_path}
    git clone ${modules_repo_url} ${clone_path} > /dev/null

  ##cd, checkout master, pull, cd back:
    cd ${modules_template_path} &>/dev/null
    git checkout master &>/dev/null
    git pull &>/dev/null
    cd - &>/dev/null
}

set_templates_repository_branch() {
  cd ${modules_template_path} &>/dev/null
  git pull &>/dev/null
  git checkout $@ &>/dev/null
  cd - &>/dev/null
}

set_templates_repository_version_tag() {

  cd ${modules_template_path} &>/dev/null

  ##set to latest tag if on master branch:
    [[ "${requested_templates_branch}" == "master" ]] \
      && module_version_tag=$(git describe --abbrev=0)

  ##set to requested_branch if a specific branch was requested:
    [[ "${requested_templates_branch}" != "master" ]] \
      && module_version_tag=$(git branch | grep '*' | cut -d\  -f 2)

  cd - &>/dev/null
}

list_available_modules() {
  [[ "${verbose}" == "true" ]] \
    && spacer \
    && echo "Listing available modules ..."

  prereqs_module $@
  shift                # <-- move past --list-available-modules

  ##clone the repository
    clone_templates_repository

  ##assume master branch unless otherwise specified:
    requested_templates_branch=master
    [[ -n ${1} ]] && requested_templates_branch=${1}
    echo "requested_templates_branch: ${requested_templates_branch}"

  ##set the repo branch:
    set_templates_repository_branch ${requested_templates_branch}

  echo "requested_templates_branch set to: ${requested_templates_branch}"
  echo 
  spacer
  echo "This is the list of currently available terraform modules."
  echo "Please contact SRE if you would like to add more:"
  spacer
  ls -1 ${modules_template_path}
  spacer

  ##set templates repo back to master:
    set_templates_repository_branch master

  exit 0
}

add_module() {
  [[ "${verbose}" == "true" ]] \
    && spacer \
    && echo "Adding module ..."

  prereqs_module $@
  shift               # <-- move past --add-module
  module_name=$1
  shift               # <-- move past module name

  ##clone the repository
    clone_templates_repository

  ##assume master branch unless otherwise specified:
    requested_templates_branch=master
    [[ -n ${1} ]] && requested_templates_branch=${1}
    echo "requested_templates_branch: ${requested_templates_branch}"

  ##checkout the requested branch:
    set_templates_repository_branch ${requested_templates_branch}

  ##set the version branch/tag:
    set_templates_repository_version_tag ${requested_templates_branch}

  ##verify module exists:
    [[ -d ${modules_template_path}/${module_name} ]] \
      || { echo "No such module '${module_name}'" \
      && exit 1 ; }

  spacer
  echo "Copying template files ..." 
  echo ""

  ##copy -n so we don't overwrite existing files:
    cp -n ${modules_template_path}/${module_name}/* .

  ##add environmentally-different variables to local dev tfvars file:
   #only add if the module_name isn't already there:
    [[ -f env_file.txt ]] \
      && {\
        grep "Module: ${module_name}" dev-us-east-1.tfvars \
          || cat env_file.txt >> dev-us-east-1.tfvars \
          && rm -f env_file.txt 
      }

  spacer

  ##kludge to deal with unportable sed behavior:
    cat ${module_name}_main.tf \
      | sed "s/\[module_version_tag\]/${module_version_tag}/g" \
      > ${module_name}_main.tf.temp
    mv -f ${module_name}_main.tf.temp ${module_name}_main.tf

  echo ""
  echo "Module pinned at: ${module_version_tag}"
  echo "Modify the ?ref in _main.tf to change this"
  spacer

  ##set templates repo back to master:
    set_templates_repository_branch master
  
  exit 0
}

prereqs_terraform() {
  [[ "${verbose}" == "true" ]] \
    && spacer \
    && echo "Running terraform prereqs ..."

  set_git_variables $@

  env_tfvars_file=$2

  verify_initialization

  verify_env_tfvars_file $@

  verify_no_examples $@

  set_common_tfvars_file_variables $@
  set_aws_variables $@

  verify_common_tfvars_file_values $@

  verify_aws_profile_exists $@

  verify_gitignore

  [[ "${verbose}" == "true" ]] \
    && display_variables $@
}

prereqs_module() {
  [[ "${verbose}" == "true" ]] \
    && spacer \
    && echo "Running module prereqs ..."

  set_git_variables $@

  set_module_variables $@
}

usage_short() {
  cat <<- EOF
  Usage (choose one):
    $(basename $0) -irm | --initialize-root-module
    $(basename $0) -lam | --list-available-modules [module_branch]
    $(basename $0) -am  | --add-module module_name [module_branch]
    $(basename $0) -p   | --plan        tfvars_file
    $(basename $0) -a   | --apply       tfvars_file
    $(basename $0) -d   | --destroy     tfvars_file
    $(basename $0) -sl  | --state-list  tfvars_file
    $(basename $0) -s   | --status      tfvars_file
    $(basename $0) -gwi | --github-workflow-init tfvars_file [module_branch]
    $(basename $0) -h   | --help
    $(basename $0) -v   | --version
    $(basename $0) --verbose <--append to any other option
EOF
}

display_readme() {
less <<- EOF
tfstack.sh                        SRE Team Manual                       tfstack.sh


NAME
     tfstack.sh -- manages terraform "stacks"

SYNOPSIS
      tfstack.sh -irm | --initialize-root-module
      tfstack.sh -lam | --list-available-modules [module_branch]
      tfstack.sh -am  | --add-module module_name [module_branch]
      tfstack.sh -p   | --plan       tfvars_file
      tfstack.sh -a   | --apply      tfvars_file
      tfstack.sh -d   | --destroy    tfvars_file
      tfstack.sh -sl  | --state-list tfvars_file
      tfstack.sh -s   | --status     tfvars_file
      tfstack.sh -gwi | --github-workflow-init tfvars_file [module_branch]
      tfstack.sh -h   | --help
      tfstack.sh -v   | --version
      tfstack.sh --verbose <--append to any other option

DESCRIPTION
     The tfstack.sh command manages terraform "stacks". It pulls
     values from the given <env>-<region>.tfvars file and uses these to
     determine the AWS profile and region in which to create
     resources. You should start with an empty directory.

CREDENTIALS
     This script relies on you having a ~/.aws/credentials file with
     valid credentials for the environment you are using. You may use
     single sign-on credentials, but they need to be pasted into your
     credentials file to work, it's how tfstack is able to tell which
     profile to use. Exporting the credentials as an environmental 
     variable won't work, because there is no way for a script to know
     which environment is configured for the exported credentials.
     
PREREQUISITES
     - Terraform remote state bucket
     - Store the name of the bucket in SSM Parameter Store named:
       "/infrastructure/terraform/state-bucket"
     - Dynamodb table named:
       TerraformLockDB

INITIALIZATION
     1. Run --initialize-root-module. This will place some required
        'core' files into your empty directory.

     2. Run --list-available-modules to obtain a list of modules
        which will work with tfstack. If you are building a new
        module in the github repo cicd-templates, you may specify
        a branch with this option. If you do not see a module listed
        here that you want, you should put in a ticket with SRE.

     3. Run --add-module to add the module you want. You may also
        specify a branch, and you may add multiple modules, though
        please be aware you may need to chase down instances of
        multiple variables declarations. 

     4. Modify all EXAMPLE values and provide 'real' values. 
        Then run the --init, --plan and --apply options 
        using the appropriate <env>-<region>.tfvars 
        file as an argument. 

     5. Run --github-workflow-init tfvars_file to copy and configure a basic
        terraform github workflow file under the root of your repository
        at .github/workflows. This file will run in the environment and region
        defined in your tfvars_file. You should run it once per tfvars_file.
        The default workflow behavior will be to run when the contents of your
        root module folder change and are checked in under a branch corresponding
        to your environment (dev workflow runs from dev branch).


USAGE
     The following options are available:

     --initialize-root-module
                - Copies core files needed to manage a terraform module. These files and tfstack
                  will manage the terraform S3 backend, declare some standard variables and provide
                  a most basic <env>-<region>.tfvars file which will work in our DEV AWS account, in
                  the us-east-1 region. You will need to replace any EXAMPLE values in those files 
                  with 'real' values.

     --list-available-modules
                - Checks out our github repository 'cicd-template' into /tmp/. Lists modules there which
                  have core template files available to populate your root module. You will need to 
                  replace any EXAMPLE values in those files 
                  with 'real' values.

     --plan
                - Runs terraform init. This safeguards the remote state file.
                  Runs terraform plan. This creates the plan.
                  Runs a number of verification steps.

     --apply
                - Runs terraform init. This safeguards the remote state file.
                  Runs terraform apply.
                  Runs a number of verification steps.

     --destroy
                - Runs terraform init. This safeguards the remote state file.
                  Runs terraform destroy.
                  Runs a number of verification steps.

     --state-list
                - Returns a list of resources via terraform state list

     --status
                - Returns the status of the terraform 'stack'.
                  Applied: resources exist
                  Destroyed: resources have been destroyed
                  No state file: resources have not been created yet

     --help | -h
                - Displays this help screen

     --version | -v
                - Displays the version of tfstack


VARIABLES


  Environment:
       DEV
       QA
       PROD
       ETC ...

  Name:
       For Tagging. May be used to create other Tags.

  Application:
       Name of the application for your code

  Owner:
       Your email

  Product:
       Whatever product your resources support

EXAMPLES
     Commands:
       tfstack.sh --initialize-root-module
       tfstack.sh --add-module s3_bucket

       [ modify EXAMPLE values in the files ]

       tfstack.sh --plan dev-us-east-1.tfvars
       tfstack.sh --apply dev-us-east-1.tfvars


Questions?  Please contact:
Put your email address here.

EOF
}

get_terraform_resource_status() {
  [[ "${verbose}" == "true" ]] \
    && spacer \
    && echo "Running get_terraform_resource_status ..."

  prereqs_terraform $@

  remote_state_file=$( \
    aws s3 ls s3://${state_bucket}/${backend_key} \
      --profile ${profile} \
      --region ${region}
  )

  [[ -z ${remote_state_file} ]] \
    && spacer \
    && { echo "Resource Status: No state file" \
    && exit 0 ; }

  resource_status=$( \
    aws s3api get-object-tagging \
      --bucket ${state_bucket} \
      --key ${backend_key} \
      --profile ${profile} \
      --region ${region} \
      | grep -A 1 TerraformResourceStatus \
      | grep Value \
      | cut -d\" -f 4 \
  )

  spacer
  echo "Resource Status: ${resource_status}"
}

main() {

  verbose_check $@
  spacer

  case "$1" in
    -p|--plan)
      terraform_plan $@
      ;;
    -a|--apply)
      terraform_apply $@
      ;;
    -d|--destroy)
      terraform_destroy $@
      ;;
    -irm|--initialize-root-module)
      initialize_root_module $@
      ;;
    -lam|--list-available-modules)
      list_available_modules $@
      ;;
    -am|--add-module)
      add_module $@
      ;;
    -gwi|--github-workflow-init)
      github_workflow_file $@
      ;;
    -sl|--state-list)
      terraform_state_list $@
      ;;
    -s|--status)
      get_terraform_resource_status $@
      ;;
    -h|--help)
      display_readme
      exit 0
      ;;
    -v|--version)
      echo "$(basename $0) version ${tfstack_version}"
      exit 0
      ;;
    *)
      usage_short
      exit 1
  esac
}

main $@

exit 0

