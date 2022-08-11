##modify these:
variable "instance_name" {
  default     = "EXAMPLE_instance_name"
}

##environment-specific variables, modify to taste:
variable "instance_type" {
  default = {
    dev-us-east-1         = "t2.micro"
    dev-us-west-2         = "t2.micro"
    qa-us-east-1          = "t2.small"
    qa-us-west-2          = "t2.small"
    prod-us-east-1        = "t2.medium"
    prod-us-west-2        = "t2.medium"
  }
}

variable "root_volume_size" {
  default = {
    dev-us-east-1        = "8"
    dev-us-west-2        = "8"
    qa-us-east-1         = "16"
    qa-us-west-2         = "16"
    prod-us-east-1       = "32"
    prod-us-west-2       = "32"
  }
}

##common variables:
variable "userdata_file" {
  default = "ec2_instance_userdata.sh"
}
variable "managed_policy_arn_list" {
  description = "ARN list which get applied to the instance-profile of the instance"
  default = [
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
  ]
}

locals {
  instance_type    = lookup(var.instance_type, "${var.environment}-${var.region}")
  root_volume_size = lookup(var.root_volume_size, "${var.environment}-${var.region}")
  ami_id           = var.ami_id == "" ? data.aws_ami.centos.id : var.ami_id
}

##defaults:
variable "key_name" {
  type        = string
  description = "ssh key for the instance to use"
  default     = ""
}
variable "ami_id" {
  type        = string
  description = "AMI ID"
  default     = ""
}
variable "subnet_id" {
  type        = string
  description = "subnet where you want the instance"
  default     = ""
}
variable "vpc_security_group_ids" {
  type        = string
  description = "list of security groups to apply to the instance"
  default     = "[]"
}
variable "timezone" { default = "New_York" }

