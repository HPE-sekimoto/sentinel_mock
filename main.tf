// GCP provider
variable "GOOGLE_CREDENTIALS" {}
variable "project" {}

data "google_iam_policy" "admin" {
  binding {
    role = "roles/compute.instanceAdmin"

    members = [
      "serviceAccount:terraform-admin@ksgadget-admin-1.iam.gserviceaccount.com",
    ]
  }

  binding {
    role = "roles/storage.objectViewer"

    members = [
      "user:ksgadget@ksgadget.site",
    ]
  }

  audit_config {
    service = "cloudkms.googleapis.com"
    audit_log_configs {
      log_type = "DATA_READ"
      exempted_members = ["user:ksgadget@ksgadget.site"]
    }

    audit_log_configs {
      log_type = "DATA_WRITE"
    }

    audit_log_configs {
      log_type = "ADMIN_READ"
    }
  }
}

# https://github.com/terraform-google-modules/terraform-google-folders

#====================================================================
# first layer folder creation
#====================================================================

module "folders1" {
  source  = "terraform-google-modules/folders/google"
  version = "~> 2.0"

  parent = var.folders_layer1.parent

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

resource "google_folder_iam_audit_config" "folders1_folder" {
  count = length(var.folders_layer1.folders)
  folder  = module.folders1.ids_list[count.index]
  service = "allServices"
  audit_log_config {
    log_type = "ADMIN_READ"
  }
  audit_log_config {
    log_type = "DATA_READ"
  }
}

resource "google_folder_iam_audit_config" "folders1_folder_specific" {
  count = length(var.folders_layer1.folders)
  folder  = module.folders1.ids_list[count.index]
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