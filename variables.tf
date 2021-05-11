variable "region" {
  description = "GCP region name"
  default     = "asia-northeast1"
}
variable "project" {
  description = "GCP project name"
  default     = "ksgadget-admin-1"
}
variable "zone" {
  description = "GCP zone name"
  default     = "asia-northeast1-c"
}
variable "zone_a" {
  description = "GCP zone name"
  default     = "asia-northeast1-a"
}
variable "zone_b" {
  description = "GCP zone name"
  default     = "asia-northeast1-b"
}
variable "zone_c" {
  description = "GCP zone name"
  default     = "asia-northeast1-c"
}
variable "env" {
  description = "environment name"
  default     = "Terraform Demo"
}
variable "db_tier" {
  description = "dababase tier name"
  default     = "db-n1-standard-1"
}
variable "network" {
  default = "test"
}
variable "mysql_version" {
  default = "MYSQL_5_7"
}
variable "postgresql_version" {
  default = "POSTGRES_9_6"
}
variable "network_name" {
  default = "default"
}
variable "mysql_ha_name" {
  type        = string
  description = "The name for Cloud SQL instance"
  default     = "tf-mysql-ha"
}
variable "mysql_ha_external_ip_range" {
  type        = string
  description = "The ip range to allow connecting from/to Cloud SQL"
  default     = "192.10.10.10/32"
}