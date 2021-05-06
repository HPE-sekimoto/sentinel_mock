variable "region" {
  description = "GCP region name"
  default     = "asia-northeast1"
}
variable "zone" {
  description = "GCP zone name"
  default     = "asia-northeast1-c"
}
variable "location" {
  description = "location"
  default = "JP"
}
variable "env" {
  description = "environment name"
  default     = "Terraform Demo"
}
variable "organization" {
  description = "organization name"
  default     = "organizations/48328552181"
}
variable "network" {
  default = "test"
}
variable "mysql_version" {
  default = "MYSQL_5_6"
}
variable "postgresql_version" {
  default = "POSTGRES_9_6"
}
variable "network_name" {
  default = "mysql-psql-example"
}