// GCP provider
variable "GOOGLE_CREDENTIALS" {}
variable "project" {}

provider "null" {
  version = "~> 2.1"
}

provider "random" {
  version = "~> 2.2"
}

module "project-factory" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"

  random_project_id       = true
  name                    = "simple-sample-project"
  org_id                  = var.organization_id
  billing_account         = var.billing_account
  credentials_path        = file("../../../.ssh/gcp_credential.json")
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