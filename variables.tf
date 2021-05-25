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
variable "vpc_name" {
  description = "VPC name"
  default     = "my-vpc"
}
variable "dns_name" {
  description = "dns name"
  default     = "my-dns"
}
variable "dns_domain" {
  description = "dns name"
  default     = "ksgadget.site."
}
