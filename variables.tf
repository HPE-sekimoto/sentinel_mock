variable "region" {
  description = "GCP region name"
  default     = "asia-northeast1"
}
variable "zone" {
  description = "GCP zone name"
  default     = "asia-northeast1-c"
}
variable "location" {
  description = "location"
  default = "JP"
}
variable "env" {
  description = "environment name"
  default     = "Terraform Demo"
}
variable "organization" {
  description = "organization name"
  default     = "organizations/48328552181"
}

variable "folders_layer1" {
  description = "folders layer1"
  type = object({
    parent  = string
    folders = list(string)
  })
  default = {
    parent  = "organizations/48328552181"
    folders = ["Dept abc", "Dept xyz", "Shared IT"]
  }
}

variable "folders_layer2_dept_abc" {
  description = "folders layer2"
  type = object({
    parent  = string
    folders = list(string)
  })
  default = {
    parent  = "Dept abc"
    folders = ["Section xyz", "Section abc"]
  }
}

variable "folders_layer2_shared_it" {
  description = "folders layer2"
  type = object({
    parent  = string
    folders = list(string)
  })
  default = {
    parent  = "Shared IT"
    folders = ["Shared Infrastructure"]
  }
}

variable "folders_layer3_section_xyz" {
  description = "folders layer3"
  type = object({
    parent  = string
    folders = list(string)
  })
  default = {
    parent  = "Section xyz"
    folders = ["EWS Application", "Application X"]
  }
}

variable "folders_layer3_shared_infrastructure" {
  description = "folders layer3"
  type = object({
    parent  = string
    folders = list(string)
  })
  default = {
    parent  = "Shared Infrastructure"
    folders = ["Production", "Non-production"]
  }
}
