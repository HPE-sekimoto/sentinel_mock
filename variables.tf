variable "region" {
  description = "GCP region name"
  default     = "asia-northeast1"
}
variable "zone" {
  description = "GCP zone name"
  default     = "asia-northeast1-c"
}
variable "organization_id" {
  description = "The organization id for the associated services"
  default     = "48328552181"
}
variable "billing_account" {
  description = "The ID of the billing account to associate this project with"
  default = "0148D8-5027F4-BCB19F"
}