// GCP provider
variable "GOOGLE_CREDENTIALS" {}
variable "project" {}
variable "org_id" {}
variable "billing_account" {}

module "project-factory" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"

  name                 = "ks-sample-1"
  random_project_id    = true
  org_id               = var.org_id
#  usage_bucket_name    = "ks-sample-1-usage-report-bucket"
#  usage_bucket_prefix  = "ks/sample/1/integration"
  billing_account      = var.billing_account
#  svpc_host_project_id = "shared_vpc_host_name"

#  shared_vpc_subnets = [
#    "projects/base-project-196723/regions/us-east1/subnetworks/default",
#    "projects/base-project-196723/regions/us-central1/subnetworks/default",
#    "projects/base-project-196723/regions/us-central1/subnetworks/subnet-1",
#  ]
}