// GCP provider
variable "GOOGLE_CREDENTIALS" {}
variable "project" {}

resource "google_compute_network" "default" {
  name                    = var.network_name
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "default" {
  name                     = var.network_name
  ip_cidr_range            = "10.127.0.0/20"
  network                  = google_compute_network.default.self_link
  region                   = var.region
  private_ip_google_access = true
}

module "mysql-db" {
  source = "GoogleCloudPlatform/sql-db/google//modules/mysql"

  name             = "testdb-1"
  database_version = var.mysql_version
  project_id       = var.project
  zone             = var.zone

  ip_configuration = {
    authorized_networks = [{
      name  = var.network_name
      value = google_compute_subnetwork.default.ip_cidr_range
    }]
    ipv4_enabled    = true
    private_network = ""
    require_ssl     = true
  }

  database_flags = [
    {
      name  = "log_bin_trust_function_creators"
      value = "on"
    },
  ]
}