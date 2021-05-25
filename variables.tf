variable "region" {
  description = "GCP region name"
  default     = "asia-northeast1"
}
variable "zone" {
  description = "GCP zone name"
  default     = "asia-northeast1-c"
}
variable "router_name" {
  description = "router name"
  default     = "rt-01"
}
variable "machine_type" {
  description = "Machine Type"
  default     = "f1-micro"
}
variable "env" {
  description = "environment name"
  default     = "Terraform Demo"
}
