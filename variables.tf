variable "region" {
  description = "GCP region name"
  default     = "asia-northeast1"
}
variable "zone" {
  description = "GCP zone name"
  default     = "asia-northeast1-c"
}
variable "router_name" {
  description = "router name"
  default     = "rt-01"
}
variable "machine_type" {
  description = "Machine Type"
  default     = "f1-micro"
}
variable "env" {
  description = "environment name"
  default     = "Terraform Demo"
}
variable "vpc_name" {
  description = "VPC name"
  default     = "my-vpc"
}
variable "dns_name" {
  description = "dns name"
  default     = "my-dns"
}
variable "dns_domain" {
  description = "dns name"
  default     = "ksgadget.site."
}
variable "roles" {
  description = "role1"
  type = list(object({
    resource_name        = string
    role_id              = string
    title                = string
    description          = string
    roles                = list(string)
    permissions          = list(string)
    excluded_permissions = list(string)
  }))
  default = [
    {
      # Permission cloudonefs.isiloncloud.com/clusters.list is not supported in custom roles
      # -> removed "roles/iam.securityAdmin"
      # The following is OK
      resource_name        = "custom_compute_admin"
      role_id              = "custom_compute_admin01"
      title                = "custom compute admin"
      description          = "custom compute admin"
      roles                = ["roles/compute.admin"]
      permissions          = []
      excluded_permissions = ["resourcemanager.projects.list", "compute.organizations.disableXpnResource", "compute.securityPolicies.copyRules", "compute.firewallPolicies.move", "compute.firewallPolicies.copyRules", "compute.securityPolicies.move", "compute.firewallPolicies.addAssociation", "compute.organizations.disableXpnHost", "compute.organizations.setFirewallPolicy", "compute.organizations.enableXpnHost", "compute.organizations.enableXpnResource", "compute.oslogin.updateExternalUser", "compute.firewallPolicies.removeAssociation", "compute.organizations.listAssociations", "compute.organizations.setSecurityPolicy", "compute.securityPolicies.addAssociation", "compute.securityPolicies.removeAssociation", "cloudonefs.isiloncloud.com/clusters.create", "cloudonefs.isiloncloud.com/clusters.delete", "cloudonefs.isiloncloud.com/clusters.get", "cloudonefs.isiloncloud.com/clusters.list", "cloudonefs.isiloncloud.com/clusters.update", "cloudonefs.isiloncloud.com/clusters.updateAdvancedSettings", "cloudonefs.isiloncloud.com/fileshares.create", "cloudonefs.isiloncloud.com/fileshares.delete", "cloudonefs.isiloncloud.com/fileshares.get", "cloudonefs.isiloncloud.com/fileshares.list", "cloudonefs.isiloncloud.com/fileshares.update", "domains.registrations.configureContact", "domains.registrations.configureDns", "domains.registrations.configureManagement", "domains.registrations.create", "domains.registrations.delete", "domains.registrations.get", "domains.registrations.getIamPolicy", "domains.registrations.list", "domains.registrations.setIamPolicy", "domains.registrations.update", "gcp.redisenterprise.com/databases.create", "gcp.redisenterprise.com/databases.delete", "gcp.redisenterprise.com/databases.get", "gcp.redisenterprise.com/databases.list", "gcp.redisenterprise.com/databases.update", "gcp.redisenterprise.com/subscriptions.create", "gcp.redisenterprise.com/subscriptions.delete", "gcp.redisenterprise.com/subscriptions.get", "gcp.redisenterprise.com/subscriptions.list", "gcp.redisenterprise.com/subscriptions.update", "servicemanagement.consumerSettings.get", "servicemanagement.consumerSettings.getIamPolicy", "servicemanagement.consumerSettings.list", "servicemanagement.consumerSettings.setIamPolicy", "servicemanagement.consumerSettings.update"]
    },
  ]
}