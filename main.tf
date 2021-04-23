// GCP provider
variable "GOOGLE_CREDENTIALS" {}
variable "project" {}

resource "google_storage_bucket" "auto-expire" {
  name          = "ks123-auto-expiring-bucket"
  location      = "JP"
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 3
    }
    action {
      type = "Delete"
    }
  }
}
