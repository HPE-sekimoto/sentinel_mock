// GCP provider
variable "GOOGLE_CREDENTIALS" {}
variable "project" {}

provider "google" {
  //credentials = file("./gcp_credential.json")
  credentials = "${var.GOOGLE_CREDENTIALS}"
  project     = var.project
  region      = var.region
}

data "google_compute_image" "my_ubuntu-pro-2004-lts" {
  family  = "ubuntu-pro-2004-lts"
  project = "ubuntu-os-pro-cloud"
}

data "google_compute_image" "my_debian_9" {
  family  = "debian-9"
  project = "debian-cloud"
}

data "google_compute_image" "my_windows_2016" {
  family  = "windows-2016"
  project = "windows-cloud"
}

resource "google_compute_instance" "vm_ubuntu-pro-2004-lts" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone
  description  = "ubuntu 2004 lts"
  tags         = ["terraform-test"]
  boot_disk {
    initialize_params {
      image = data.google_compute_image.my_ubuntu-pro-2004-lts.self_link
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

resource "google_kms_key_ring" "keyring" {
  name     = "keyring-example"
  location = "global"
}

resource "google_kms_crypto_key" "customer_key" {
  name            = "crypto-key-example"
  key_ring        = google_kms_key_ring.keyring.id
  rotation_period = "100000s"

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_compute_disk" "ext_disk" {
  name  = "testdisk"
  type  = "pd-ssd"
  zone = var.zone
  size = 16
  disk_encryption_key {
    raw_key = google_kms_crypto_key.customer_key.self_link
  }
}

module "bucket" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "~> 1.3"

  name       = "example-xxx-bucket"
  project_id = var.project
  location   = "asia-northeast1"
  encryption = {
    default_kms_key_name = "crypto-key-example"
  }
}