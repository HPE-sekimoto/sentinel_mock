// GCP provider
variable "GOOGLE_CREDENTIALS" {}
variable "project" {}

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

#====================================================================
# second layer folder creation
#====================================================================

module "folders_dept_abc" {
  source  = "terraform-google-modules/folders/google"
  version = "~> 2.0"

  parent = module.folders1.ids[var.folders_layer2_dept_abc.parent]

  names = var.folders_layer2_dept_abc.folders

  depends_on = [
    module.folders1.folders,
  ]
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

resource "google_folder_iam_audit_config" "folders_dept_abc_folder" {
  count = length(module.folders_dept_abc.folders)
  folder  = module.folders_dept_abc.ids_list[count.index]
  service = "allServices"
  audit_log_config {
    log_type = "ADMIN_READ"
  }
  audit_log_config {
    log_type = "DATA_READ"
  }
  depends_on = [
    module.folders_dept_abc.folders,
  ]
}

module "folders_shared_it" {
  source  = "terraform-google-modules/folders/google"
  version = "~> 2.0"

  parent = module.folders1.ids[var.folders_layer2_shared_it.parent]

  names = var.folders_layer2_shared_it.folders

  depends_on = [
    module.folders1.folders,
  ]
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

resource "google_folder_iam_audit_config" "folders_shared_it_folder" {
  count = length(module.folders_shared_it.folders)
  folder  = module.folders_shared_it.ids_list[count.index]
  service = "allServices"
  audit_log_config {
    log_type = "ADMIN_READ"
  }
  audit_log_config {
    log_type = "DATA_READ"
  }
  depends_on = [
    module.folders_shared_it.folders,
  ]
}

#====================================================================
# third layer folder creation
#====================================================================

module "folders_section_xyz" {
  source  = "terraform-google-modules/folders/google"
  version = "~> 2.0"

  parent = module.folders_dept_abc.ids[var.folders_layer3_section_xyz.parent]

  names = var.folders_layer3_section_xyz.folders

  depends_on = [
    module.folders_dept_abc.folders,
  ]
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

resource "google_folder_iam_audit_config" "folders_section_xyz_folder" {
  count = length(module.folders_section_xyz.folders)
  folder  = module.folders_section_xyz.ids_list[count.index]
  service = "allServices"
  audit_log_config {
    log_type = "ADMIN_READ"
  }
  audit_log_config {
    log_type = "DATA_READ"
  }
  depends_on = [
    module.folders_section_xyz.folders,
  ]
}

module "folders_shared_infrastructure" {
  source  = "terraform-google-modules/folders/google"
  version = "~> 2.0"

  parent = module.folders_shared_it.ids[var.folders_layer3_shared_infrastructure.parent]

  names = var.folders_layer3_shared_infrastructure.folders

  depends_on = [
    module.folders_shared_it.folders,
  ]
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

resource "google_folder_iam_audit_config" "folders_shared_infrastructure_folder" {
  count = length(module.folders_shared_infrastructure.folders)
  folder  = module.folders_shared_infrastructure.ids_list[count.index]
  service = "allServices"
  audit_log_config {
    log_type = "ADMIN_READ"
  }
  audit_log_config {
    log_type = "DATA_READ"
  }
  depends_on = [
    module.folders_shared_infrastructure.folders,
  ]
}