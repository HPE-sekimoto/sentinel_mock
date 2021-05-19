// GCP provider
variable "GOOGLE_CREDENTIALS" {}
variable "project_id" {}

# Building the list of disk names in the required format.
# Usually you would build this list from the outputs of the compute_instance module
locals {
  instance_disks = [for i in range(2) : "projects/${var.project_id}/disks/instance-simple-001-${i + 1}/zones/${data.google_compute_zones.available.names[0]}"]
}

data "google_compute_zones" "available" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_disk" "default" {
  name  = "test-disk"
  type  = "pd-ssd"
  size  = 50
  zone  = var.zone
  image = "debian-9-stretch-v20200805"
  labels = {
    environment = "dev"
  }
  physical_block_size_bytes = 4096
}

resource "google_compute_network" "example" {
  name = "example"
}

resource "google_compute_subnetwork" "subnet1" {
  name          = "subnet1"
  ip_cidr_range = "192.168.10.0/24"
  network       = google_compute_network.example.name
  description   = "example.subnet1"
  region        = var.region
}

module "instance_template" {
  source          = "terraform-google-modules/vm/google//modules/instance_template"
  version         = "6.3.0"
  region          = var.region
  project_id      = var.project_id
  subnetwork      = google_compute_subnetwork.subnet1.name
  service_account = var.service_account

  disk_size_gb = 30
  disk_type    = "pd-standard"

  additional_disks = [
    {
      auto_delete  = true
      boot         = false
      disk_size_gb = 20
      disk_type    = "pd-standard"
      disk_name    = null
      device_name  = null
    },
    {
      auto_delete  = true
      boot         = false
      disk_size_gb = 30
      disk_type    = "pd-standard"
      disk_name    = null
      device_name  = null
    }
  ]

  depends_on = [
    google_compute_subnetwork.subnet1,
  ]
}

module "compute_instance" {
  source  = "terraform-google-modules/vm/google//modules/compute_instance"
  version = "6.3.0"

  region            = var.region
  num_instances     = 1
  hostname          = "instance-simple"
  instance_template = module.instance_template.self_link
  subnetwork        = google_compute_subnetwork.subnet1.name

  depends_on = [
    module.instance_template.self_link,
  ]
}

module "disk_snapshots" {
  source  = "terraform-google-modules/vm/google//modules/compute_disk_snapshot"
  version = "6.3.0"

  name    = "backup-policy-test"
  project = var.project_id
  region  = var.region

  snapshot_retention_policy = {
    max_retention_days    = 10
    on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
  }

  snapshot_schedule = {
    daily_schedule = {
      days_in_cycle = 1
      start_time    = "08:00"
    }
    hourly_schedule = null
    weekly_schedule = null
  }

  snapshot_properties = {
    guest_flush       = true
    storage_locations = ["EU"]
    labels            = null
  }

  module_depends_on = [module.compute_instance]
  disks             = local.instance_disks
}
