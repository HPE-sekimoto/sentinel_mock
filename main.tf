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

data "google_compute_image" "my_debian_9" {
  family  = "debian-9"
  project = "debian-cloud"
}

data "google_compute_image" "my_windows_2016" {
  family  = "windows-2016"
  project = "windows-cloud"
}

resource "google_compute_instance" "vm_debian_9" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone
  description  = "debian 9"
  tags         = ["terraform-test"]
  boot_disk {
    initialize_params {
      image = data.google_compute_image.my_debian_9.self_link
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

resource "google_compute_instance" "vm_windows_2016" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone
  description  = "gcp-terraform-test"
  tags         = ["terraform-test"]
  boot_disk {
    initialize_params {
      image = data.google_compute_image.my_windows_2016.self_link
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