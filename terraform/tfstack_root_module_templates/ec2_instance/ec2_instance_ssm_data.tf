data "aws_ssm_parameter" "on_prem_internal_cidrs_sg_id" {
  name = "/infrastructure/on_prem_internal_cidrs_sg-id"
}
data "aws_ssm_parameter" "on_prem_outbound_cidrs_sg_id" {
  name = "/infrastructure/on_prem_outbound_cidrs_sg-id"
}
data "aws_ssm_parameter" "vpc_internal_cidr_sg_id" {
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
data "aws_ssm_parameter" "keypair" {
  name = "/infrastructure/dssp/default-keypair-name"
}

