variable "region" {
  description = "GCP region name"
  default     = "asia-northeast1"
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
variable "ip_white_list" {
  description = "A list of ip addresses that can be white listed through security policies"
  default     = ["192.0.2.0/24"]
}