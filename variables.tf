variable "region" {
  description = "GCP region name"
  default     = "asia-northeast1"
}
variable "zone" {
  description = "GCP zone name"
  default     = "asia-northeast1-c"
}
variable "role_compute_admin" {
  description = "roles"
  type = object({
    role    = string
    members = list(string)
  })
  default = {
    role    = "custom_compute_admin01"
    members = ["user:ksekimoto@ksgadget.site", "user:ksgadget@ksgadget.site"]
  }
}

