// GCP provider
variable "GOOGLE_CREDENTIALS" {}
variable "project_id" {}
variable "project" {}
// GCP provider
provider "google" {
  project     = var.project_id
  region      = var.region
}

provider "google-beta" {
  project = var.project_id
}

module "cloud_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 0.4"

  project = var.project_id # Replace this with your project ID in quotes
  name    = "my-cloud-router"
  network = "default"
  region  = var.region

  nats = [{
    name = "nat-gateway"
  }]
}
