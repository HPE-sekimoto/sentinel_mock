// GCP provider
variable "GOOGLE_CREDENTIALS" {}
variable "project" {}

provider "google" {
  //credentials = file("./gcp_credential.json")
  credentials = "${var.GOOGLE_CREDENTIALS}"
  project     = var.project
  region      = var.region
}

# resource "google_app_engine_application" "appflex" {
#   project     = var.project
#   location_id = var.region
# }

resource "google_compute_instance" "terraform-test" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone
  description  = "gcp-terraform-test"
  tags         = ["terraform-test"]
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }
  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro", "monitoring"]
  }
}