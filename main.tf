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

module "vpc" {
    source  = "terraform-google-modules/network/google"
    version = "~> 3.0"

    project_id   = var.project_id
    network_name = var.vpc_name
    routing_mode = "GLOBAL"

    subnets = [
        {
            subnet_name           = "subnet-01"
            subnet_ip             = "10.10.10.0/24"
            subnet_region         = var.region
        },
        {
            subnet_name           = "subnet-02"
            subnet_ip             = "10.10.20.0/24"
            subnet_region         = var.region
            subnet_private_access = "true"
            subnet_flow_logs      = "true"
            description           = "This subnet has a description"
        },
        {
            subnet_name               = "subnet-03"
            subnet_ip                 = "10.10.30.0/24"
            subnet_region             = var.region
            subnet_flow_logs          = "true"
            subnet_flow_logs_interval = "INTERVAL_10_MIN"
            subnet_flow_logs_sampling = 0.7
            subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
        }
    ]

    secondary_ranges = {
        subnet-01 = [
            {
                range_name    = "subnet-01-secondary-01"
                ip_cidr_range = "192.168.64.0/24"
            },
        ]

        subnet-02 = []
    }

    routes = [
        {
            name                   = "egress-internet"
            description            = "route through IGW to access internet"
            destination_range      = "0.0.0.0/0"
            tags                   = "egress-inet"
            next_hop_internet      = "true"
        },
#        {
#            name                   = "app-proxy"
#            description            = "route through proxy to reach app"
#            destination_range      = "10.50.10.0/24"
#            tags                   = "app-proxy"
#            next_hop_instance      = "app-proxy-instance"
#            next_hop_instance_zone = "us-west1-a"
#        },
    ]
}

module "dns-private-zone" {
  source  = "terraform-google-modules/cloud-dns/google"
  version = "3.0.0"
  project_id = var.project_id
  type       = "private"
  name       = var.dns_name
  domain     = var.dns_domain

  private_visibility_config_networks = [
    "https://www.googleapis.com/compute/v1/projects/red-minutia-275210/global/networks/my-vpc"
  ]

  recordsets = [
#    {
#      name    = ""
#      type    = "NS"
#      ttl     = 300
#      records = [
#        "127.0.0.1",
#      ]
#    },
#    {
#      name    = "localhost"
#      type    = "A"
#      ttl     = 300
#      records = [
#        "127.0.0.1",
#      ]
#    },
  ]

  depends_on = [
    module.vpc
  ]
}