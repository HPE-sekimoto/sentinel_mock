variable "region" {
  description = "GCP region name"
  default     = "asia-northeast1"
}
variable "project" {
  description = "GCP project name"
  default     = "optimal-mender-309507"
}
variable "zone" {
  description = "GCP zone name"
  default     = "asia-northeast1-c"
}
variable "vm_name" {
  description = "VM name"
  default     = "ks-terraform-test"
}
variable "machine_type" {
  description = "Machine Type"
  default     = "f1-micro"
}
variable "env" {
  description = "environment name"
  default     = "Terraform Demo"
}