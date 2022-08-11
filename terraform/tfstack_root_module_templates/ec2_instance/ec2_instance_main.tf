module "ec2_instance" {
  source = "git@github.com:goodysinclair/tfstack.git//terraform/modules/ec2_instance?ref=[module_version_tag]"

  instance_name           = var.instance_name
  managed_policy_arn_list = var.managed_policy_arn_list
  userdata_file           = var.userdata_file
  instance_type           = local.instance_type
  ami_id                  = local.ami_id
  root_volume_size        = local.root_volume_size
  key_name                = data.aws_ssm_parameter.keypair.value
  policy                  = data.aws_iam_policy_document.policy.json
  assume_role_policy      = data.aws_iam_policy_document.assume_role_policy.json
  subnet_id               = data.aws_ssm_parameter.private_subnet_1.value
  vpc_security_group_ids = [
    data.aws_ssm_parameter.on_prem_internal_cidrs_sg_id.value,
    data.aws_ssm_parameter.vpc_internal_cidr_sg_id.value
  ]
  environment        = var.environment
  region             = var.region
  common_tags        = local.common_tags
}

