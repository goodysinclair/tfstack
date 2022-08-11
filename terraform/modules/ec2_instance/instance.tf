resource "aws_instance" "instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id              = var.subnet_id
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  user_data = templatefile(
    var.userdata_file,
    {
      environment            = var.environment,
      region                 = var.region,
      timezone               = var.timezone,
    }
  )
  root_block_device {
    volume_size = var.root_volume_size
  }

  tags = merge(
    var.common_tags,
    { Name = var.instance_name }
  )
  volume_tags = merge(
    var.common_tags,
    { Name = var.instance_name }
  )
}

