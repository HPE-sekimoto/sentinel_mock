// GCP provider
variable "GOOGLE_CREDENTIALS" {}
variable "project" {}

provider google-beta {}
provider tls{}

# variable "project_id" {
#  type = string
# }

# variable "location" {
#  type = string
#}

resource "random_string" "randomca" {
  length = 8
  special = false
}

resource "tls_private_key" "example" {
  algorithm   = "RSA"
}

resource "tls_cert_request" "example" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.example.private_key_pem

  subject {
    common_name  = "example.com"
    organization = "ACME Examples, Inc"
  }
}

resource "google_privateca_certificate_authority" "ca" {
  provider = google-beta
  certificate_authority_id = format("%s-%s",random_string.randomca.result,"ca")
  location = var.location
  lifetime = "30000s"
  project = var.project
  type = "SELF_SIGNED"
  key_spec {
    algorithm = "RSA_PSS_2048_SHA256"
  }
  tier = "ENTERPRISE"
  config  {
    subject_config  {
      common_name = "My Certificate Authority"
      subject {
        country_code = "us"
        organization = "google"
        organizational_unit = "enterprise"
        locality = "mountain view"
        province = "california"
        street_address = "1600 amphitheatre parkway"
        postal_code = "94109"
      }
    }
    reusable_config {
      reusable_config = format("projects/privateca-data/locations/%s/reusableConfigs/root-unconstrained", var.location)
    }
  }
  disable_on_delete = true
}


resource "google_privateca_certificate" "config" {
  provider = google-beta
  certificate_authority = google_privateca_certificate_authority.ca.certificate_authority_id
  project = var.project
  location = var.location
  lifetime = "860s"
  name = format("%s-%s",random_string.randomca.result,"cert-config")
  config {
      reusable_config {
        reusable_config = format("projects/privateca-data/locations/%s/reusableConfigs/leaf-server-tls", var.location)
      }
      subject_config  {
          subject_alt_name {
            dns_names = ["joonix.net"]
            email_addresses = ["email@example.com"]
            ip_addresses = ["127.0.0.1"]
            uris = ["http://www.ietf.org/rfc/rfc3986.txt"]
          }
      }
    public_key {
      type = "PEM_RSA_KEY"
      key = base64encode(tls_private_key.example.public_key_pem)
    }
  }
}

resource "google_privateca_certificate" "pem" {
  provider = google-beta
  certificate_authority = google_privateca_certificate_authority.ca.certificate_authority_id
  project = var.project
  location = var.location
  lifetime = "860s"
  name = format("%s-%s",random_string.randomca.result,"csr-config")
  pem_csr = tls_cert_request.example.cert_request_pem
}

output "cert_specs_config" {
  value = google_privateca_certificate.config.pem_certificate
}

output "cert_specs_pem" {
  value = google_privateca_certificate.pem.pem_certificate
}
