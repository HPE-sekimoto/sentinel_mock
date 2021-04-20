variable "region" {
  description = "GCP region name"
  default     = "asia-northeast1"
}
variable "zone" {
  description = "GCP zone name"
  default     = "asia-northeast1-c"
}
variable "subnetwork" {
  description = "The subnetwork selflink to host the compute instances in"
  # default     = "projects/ksgadget-admin-1/regions/asia-northeast1/subnetworks/subnet-0"
  default     = "subnet-0"
}
variable "num_instances" {
  description = "Number of instances to create"
  default     = 1
}
variable "nat_ip" {
  description = "Public ip address"
  default     = null
}
variable "network_tier" {
  description = "Network network_tier"
  default     = "PREMIUM"
}
variable "service_account" {
  type = object({
    email  = string,
    scopes = list(string)
  })
  description = ""
  default = {
    email  = "terraform-admin@ksgadget-admin-1.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
}

