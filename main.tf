// GCP provider
variable "GOOGLE_CREDENTIALS" {}
variable "PROJECT_ID" {}

provider "google" {
  //credentials = file("./gcp_credential.json")
  credentials = "${var.GOOGLE_CREDENTIALS}"
  project     = "${var.PROJECT_ID}"
  region      = var.region
}

resource "google_app_engine_application" "app" {
  project     = var.project
  location_id = var.region
}
