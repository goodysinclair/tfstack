/*
  Include whatever you like here. Most accounts should have as part of the
  core infrastructure a slew of these for things like security groups, subnets,
  vpcs, Route53 hosted zones, etc. Please look in the Parameter Store of your
  local AWS account and grab items from there if you need them. This sample
  file should include everything you need for most things, and there is no
  harm in having ones in here that your module doesn't need, though it
  might cause confusion if you include a lot of them.
*/

## ^delete this line and above^ ##

data "aws_ssm_parameter" "company_environment_public_hosted_zone_name" {
  description = "env-specific hosted zone"
  name = "/infrastructure/route53/somecompany-environment.org-public-hosted-zone-name"
}
data "aws_ssm_parameter" "somecompany_environment_public_hosted_zone_id" {
  description = "env-specific hosted zone"
  name = "/infrastructure/route53/somecompany-environment.org-public-hosted-zone-id"
}
data "aws_ssm_parameter" "somecompany_environment_private_hosted_zone_name" {
  description = "env-specific hosted zone"
  name = "/infrastructure/route53/somecompany-environment.org-private-hosted-zone-name"
}
data "aws_ssm_parameter" "somecompany_environment_private_hosted_zone_id" {
  description = "env-specific hosted zone"
  name = "/infrastructure/route53/somecompany-environment.org-private-hosted-zone-id"
}
data "aws_ssm_parameter" "somecompany_environment_certificate_arn" {
  description = "env-specific certificate"
  name = "/infrastructure/acm/somecompany-environment.org-arn"
}
data "aws_ssm_parameter" "on_prem_internal_cidrs_sg_id" {
  name = "/infrastructure/on_prem_internal_cidrs_sg-id"
}
data "aws_ssm_parameter" "on_prem_outbound_cidrs_sg_id" {
  name = "/infrastructure/on_prem_outbound_cidrs_sg-id"
}
data "aws_ssm_parameter" "vpc_internal_cidr_sg" {
  name = "/infrastructure/vpc_internal_cidr_sg-id"
}
data "aws_ssm_parameter" "primary_vpc_id" {
  name = "/infrastructure/primary-vpc-id"
}
data "aws_ssm_parameter" "private_subnet_1" {
  name = "/infrastructure/private-subnet-1-id"
}
data "aws_ssm_parameter" "private_subnet_2" {
  name = "/infrastructure/private-subnet-2-id"
}
data "aws_ssm_parameter" "private_subnet_3" {
  name = "/infrastructure/private-subnet-3-id"
}
data "aws_ssm_parameter" "public_subnet_1" {
  name = "/infrastructure/public-subnet-1-id"
}
data "aws_ssm_parameter" "public_subnet_2" {
  name = "/infrastructure/public-subnet-2-id"
}
data "aws_ssm_parameter" "public_subnet_3" {
  name = "/infrastructure/public-subnet-3-id"
}
data "aws_ssm_parameter" "waf_acl" {
  name = "WebAclId"
}
data "aws_ssm_parameter" "keypair" {
  name = "/infrastructure/ec2/default-keypair-name"
}

