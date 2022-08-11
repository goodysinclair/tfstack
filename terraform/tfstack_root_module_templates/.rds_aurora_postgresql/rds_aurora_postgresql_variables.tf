variable "cluster_name" {
  type = string
  default = ""
  description = "Name for the RDS cluster"
}
variable "master_username" {
  type = string
  default = ""
  description = "Make this a good name"
}
variable "master_password" {
  type = string
  default = ""
  description = "Change this after the cluster gets created!"
}
variable "backup_retention_period" {
  type = string
  default = ""
  description = "Number of days to keep the backup"
}
variable "final_snapshot_identifier" {
  type = string
  default = ""
  description = "Name for the final snapshot when destroyed"
}
variable "engine_mode" {
  type = string
  default = ""
  description = "global, multimaster, parallelquery, provisioned, serverless"
}
variable "subnet_group_subnet_ids" {
  type = list(string)
  default = "[]"
  description = "List of subnet IDs in which to place the cluster"
}
variable "vpc_id" {
  type = string
  default = ""
  description = "VPC ID containing the subnet IDs in the subnet group"
}
variable "security_group_ids" {
  type = list(string)
  default = ""
  description = "Security groups to apply to the cluster"
}
variable "apply_immediately" {
  type = string
  default = "true"
  description = "Apply changes immediately or wait until maintenance window, true or false"
}
variable "preferred_backup_window" {
  type = string
  default = "07:00-09:00"
  description = "UTC ... pick a time of least activity"
}
variable "preferred_maintenance_window" {
  type = string
  default = "02:00-03:00"
  description = "UTC window for maintenance"
}
variable "skip_final_snapshot" {
  type = string
  default = "true"
  description = "Set to true or false"
}
variable "enable_http_endpoint" {
  type = string
  default = "false"
  description = "Only works with engine_mode 'serverless'"
}
variable "deletion_protection" {
  type = string
  default = "false"
  description = "Enable deletion protection true or false"
}

