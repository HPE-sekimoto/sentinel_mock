// GCP provider
variable "GOOGLE_CREDENTIALS" {}
variable "project" {}
variable "org_id" {}
variable "billing_account" {}

module "organization-iam-bindings" {
  source  = "terraform-google-modules/iam/google//modules/organizations_iam"
  version = "~> 6.4"

  organizations = [var.org_id]

  bindings = {
    "organizations/${var.org_id}/roles/${var.role_compute_admin.role}" = var.role_compute_admin.members
  }
}
