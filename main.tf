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
  project_id = var.PROJECT_ID
  location   = "asia-northeast1"
}

resource "google_compute_network" "custom-test" {
  name                    = "log-test-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet-with-logging" {
  name          = "log-test-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.custom-test.id

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}
