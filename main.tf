// GCP provider
variable "GOOGLE_CREDENTIALS" {}
variable "project" {}

// GCP provider
provider "google" {
  credentials = file("../../../.ssh/ksgadget-admin-1-57ec6bc5197f.json")
  project     = var.project
  region      = var.region
}

resource "google_compute_network" "default" {
  name                    = var.network_name
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "default" {
  name                     = var.network_name
  ip_cidr_range            = "192.10.10.10/32"
  network                  = google_compute_network.default.self_link
  region                   = var.region
  private_ip_google_access = true
}

provider "null" {
  version = "~> 2.1"
}

provider "random" {
  version = "~> 2.2"
}

locals {
  read_replica_ip_configuration = {
    ipv4_enabled    = true
    require_ssl     = false
    private_network = null
    authorized_networks = [
      {
        name  = "${var.project}-cidr"
        value = var.mysql_ha_external_ip_range
      },
    ]
  }

}

module "mysql" {
  source               = "GoogleCloudPlatform/sql-db/google//modules/mysql"
  name                 = var.mysql_ha_name
  random_instance_name = true
  project_id           = var.project
  database_version     = var.mysql_version
  region               = var.region

  deletion_protection = false

  // Master configurations
  tier                            = "db-n1-standard-1"
  zone                            = var.zone
  availability_type               = "REGIONAL"
  maintenance_window_day          = 7
  maintenance_window_hour         = 12
  maintenance_window_update_track = "stable"

  database_flags = [{ name = "long_query_time", value = 1 }]

  user_labels = {
    foo = "bar"
  }

  ip_configuration = {
    ipv4_enabled    = true
    require_ssl     = true
    private_network = null
    authorized_networks = [
      {
        name  = "${var.project}-cidr"
        value = var.mysql_ha_external_ip_range
      },
    ]
  }

  backup_configuration = {
    enabled            = true
    binary_log_enabled = true
    start_time         = "20:55"
    location           = null
  }

  // Read replica configurations
  read_replica_name_suffix = "-test"
  read_replicas = [
    {
      name             = "0"
      zone             = var.zone_a
      tier             = var.db_tier
      ip_configuration = local.read_replica_ip_configuration
      database_flags   = [{ name = "long_query_time", value = 1 }]
      disk_autoresize  = null
      disk_size        = null
      disk_type        = "PD_HDD"
      user_labels      = { bar = "baz" }
    },
    {
      name             = "1"
      zone             = var.zone_b
      tier             = var.db_tier
      ip_configuration = local.read_replica_ip_configuration
      database_flags   = [{ name = "long_query_time", value = 1 }]
      disk_autoresize  = null
      disk_size        = null
      disk_type        = "PD_HDD"
      user_labels      = { bar = "baz" }
    },
    {
      name             = "2"
      zone             = var.zone_c
      tier             = var.db_tier
      ip_configuration = local.read_replica_ip_configuration
      database_flags   = [{ name = "long_query_time", value = 1 }]
      disk_autoresize  = null
      disk_size        = null
      disk_type        = "PD_HDD"
      user_labels      = { bar = "baz" }
    },
  ]

  db_name      = var.mysql_ha_name
  db_charset   = "utf8mb4"
  db_collation = "utf8mb4_general_ci"

  additional_databases = [
    {
      name      = "${var.mysql_ha_name}-additional"
      charset   = "utf8mb4"
      collation = "utf8mb4_general_ci"
    },
  ]

  user_name     = "tftest"
  user_password = "foobar"

  additional_users = [
    {
      name     = "tftest2"
      password = "abcdefg"
      host     = "localhost"
    },
    {
      name     = "tftest3"
      password = "abcdefg"
      host     = "localhost"
    },
  ]
}

