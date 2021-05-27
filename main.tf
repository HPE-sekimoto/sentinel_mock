// GCP provider
variable "GOOGLE_CREDENTIALS" {}
variable "project_id" {}
variable "project" {}
variable "organization_id" {}
variable "billing_account" {}
// GCP provider
provider "google" {
  project     = var.project_id
  region      = var.region
}

provider "google-beta" {
  project = var.project_id
}

provider "null" {
  version = "~> 2.1"
}

provider "random" {
  version = "~> 2.2"
}

module "folders1" {
  source  = "terraform-google-modules/folders/google"
  version = "~> 2.0"

  parent = "organizations/${var.organization_id}"

  names = var.folders_layer1.folders

  #  set_roles = true

  #  per_folder_admins = {
  #    dev = "group:gcp-developers@domain.com"
  #    staging = "group:gcp-qa@domain.com"
  #    production = "group:gcp-ops@domain.com"
  #  }

  #  all_folder_admins = [
  #    "group:gcp-security@domain.com",
  #  ]
}

module "project-factory" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"

  random_project_id       = true
  name                    = "mvc01-dev"
  org_id                  = var.organization_id
  billing_account         = var.billing_account
  # credentials_path        = file("../../../.ssh/gcp_credential.json")
  default_service_account = "deprivilege"

  activate_api_identities = [{
    api = "healthcare.googleapis.com"
    roles = [
      "roles/healthcare.serviceAgent",
      "roles/bigquery.jobUser",
    ]
  }]
}

resource "google_project_iam_audit_config" "project_allservices" {
  project = module.project-factory.project_id
  service = "allServices"
  audit_log_config {
    log_type = "ADMIN_READ"
  }
  audit_log_config {
    log_type = "DATA_READ"
    exempted_members = [
      "user:ksekimoto@ksgadget.site",
    ]
  }
}

resource "google_project_iam_audit_config" "project_appengine" {
  project = module.project-factory.project_id
  service = "appengine.googleapis.com"
  audit_log_config {
    log_type = "ADMIN_READ"
  }
  audit_log_config {
    log_type = "DATA_READ"
  }
  audit_log_config {
    log_type = "DATA_WRITE"
  }
}