variable "region" {
  description = "GCP region name"
  default     = "asia-east1"
}
variable "zone" {
  description = "GCP zone name"
  default     = "asia-east1-a"
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
