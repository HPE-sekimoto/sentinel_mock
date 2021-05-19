// GCP provider
variable "GOOGLE_CREDENTIALS" {}
variable "project_id" {}

resource "google_compute_address" "static1" {
  name = "ipv4-address"
  network_tier = "STANDARD"
  description = "static ip for my_ubuntu"
}

resource "google_compute_address" "static2" {
  name = "ipv4-address"
  network_tier = "STANDARD"
  description = "static ip for my_ubuntu"
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
    kms_key_self_link = google_kms_crypto_key.customer_key.self_link
  }
  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.static1.address
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
    kms_key_self_link = google_kms_crypto_key.customer_key.self_link
  }
  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.static2.address
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
    prevent_destroy = false
  }
}

resource "google_compute_disk" "ext_disk1" {
  name  = "testdisk"
  type  = "pd-ssd"
  zone = var.zone
  size = 16
  disk_encryption_key {
    raw_key = google_kms_crypto_key.customer_key.self_link
  }
}

resource "google_compute_disk" "ext_disk2" {
  name  = "testdisk"
  type  = "pd-ssd"
  zone = var.zone
  size = 16
}

module "bucket1" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "~> 1.3"

  name       = "example-xxx-bucket1"
  project_id = var.project_id
  location   = "asia-northeast1"
  encryption = {
    default_kms_key_name = "crypto-key-example"
  }
}

module "bucket2" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "~> 1.3"

  name       = "example-xxx-bucket2"
  project_id = var.project_id
  location   = "asia-northeast1"
}