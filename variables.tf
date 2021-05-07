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

variable "folders_layer1" {
  description = "folders layer1"
  type = object({
    parent  = string
    folders = list(string)
  })
  default = {
    parent  = "organizations/48328552181"
    folders = ["Dept abc", "Dept xyz", "Shared IT"]
  }
}