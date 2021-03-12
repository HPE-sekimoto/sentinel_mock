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
  project     = var.PROJECT_ID
  location_id = var.region
}

module "bucket" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "~> 1.3"

  name       = "example-xxx-bucket"
  project_id = var.project
  location   = "asia-northeast1"
}