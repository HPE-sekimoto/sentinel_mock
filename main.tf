// GCP provider
variable "GOOGLE_CREDENTIALS" {}
variable "project" {}

provider "google" {
  //credentials = file("./gcp_credential.json")
  credentials = "${var.GOOGLE_CREDENTIALS}"
  project     = var.project
  region      = var.region
}

module "agent_policy" {
  source  = "terraform-google-modules/cloud-operations/google//modules/agent-policy"
  version = "~> 0.1.0"

  project_id = var.project
  policy_id  = "ops-agents-example-policy"
  agent_rules = [
    {
      type               = "logging"
      version            = "current-major"
      package_state      = "installed"
      enable_autoupgrade = true
    },
    {
      type               = "metrics"
      version            = "current-major"
      package_state      = "installed"
      enable_autoupgrade = true
    },
  ]
  group_labels = [
    {
      env = "prod"
      app = "myproduct"
    }
  ]
  os_types = [
    {
      short_name = "centos"
      version    = "8"
    },
  ]
}
