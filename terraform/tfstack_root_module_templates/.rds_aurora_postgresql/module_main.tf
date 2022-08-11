## This file calls your module, 'module_version_tag' gets replaced with the latest git version tag on the
 # templates repo or the branch, if specified when adding the module via tfstack. Simply include all the 
 # variables your module needs. Set them all like you see below ... the user of you module should not need
 # to edit this file

## ^delete above this line^ ##

module "ssm_command_document" {
  source = "git@github.com:MassMedicalSociety/cicd-templates.git//terraform/modules/YOUR_MODULE_DIRECTORY?ref=[module_version_tag]"
  variable_1  = var.variable_1
  variable_2  = var.variable_2
  environment = var.environment
  region      = var.region
  common_tags = local.common_tags
}

