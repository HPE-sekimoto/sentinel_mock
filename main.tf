// GCP provider
provider "google" {
  credentials = file("../../../.ssh/ksgadget-admin-1-1dd7dcdd2fdc.json")
  project     = var.project
  region      = var.region
}

resource "google_app_engine_application" "app" {
  project     = var.project
  location_id = var.region
}
