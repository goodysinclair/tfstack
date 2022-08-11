output "id" {
  value = aws_instance.instance.id
}
output "arn" {
  value = aws_instance.instance.arn
}
output "availability_zone" {
  value = aws_instance.instance.availability_zone
}
output "placement_group" {
  value = aws_instance.instance.placement_group
}
output "key_name" {
  value = aws_instance.instance.key_name
}
output "password_data" {
  value = aws_instance.instance.password_data
}
output "public_dns" {
  value = aws_instance.instance.public_dns
}
output "public_ip" {
  value = aws_instance.instance.public_ip
}
output "ipv6_addresses" {
  value = aws_instance.instance.ipv6_addresses
}
output "primary_network_interface_id" {
  value = aws_instance.instance.primary_network_interface_id
}
output "private_dns" {
  value = aws_instance.instance.private_dns
}
output "private_ip" {
  value = aws_instance.instance.private_ip
}
output "security_groups" {
  value = aws_instance.instance.security_groups
}
output "vpc_security_group_ids" {
  value = aws_instance.instance.vpc_security_group_ids
}
output "subnet_id" {
  value = aws_instance.instance.subnet_id
}
output "outpost_arn" {
  value = aws_instance.instance.outpost_arn
}
output "credit_specification" {
  value = aws_instance.instance.credit_specification
}
output "instance_state" {
  value = aws_instance.instance.instance_state
}

