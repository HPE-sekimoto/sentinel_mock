// GCP provider
variable "GOOGLE_CREDENTIALS" {}
variable "project" {}

resource "google_storage_bucket" "bucket1" {
  name          = "ks124_auto_expiring_bucket"

  project = var.project
  location      = var.region
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

resource "google_storage_bucket_acl" "image_store_acl" {
  bucket = google_storage_bucket.bucket1.name

  role_entity = [
    "OWNER:user-ksekimoto@ksgadget.site",
    "READER:user-ksgadget@ksgadget.site",
  ]
}

resource "google_storage_bucket_access_control" "public_rule" {
  bucket = google_storage_bucket.bucket1.name
  role   = "READER"
  entity = "allUsers"
}
