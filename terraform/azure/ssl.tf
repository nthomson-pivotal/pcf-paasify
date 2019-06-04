provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"

  version = "~> 1.0.1"
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = "${tls_private_key.private_key.private_key_pem}"
  email_address   = "none@paasify.org"
}

resource "acme_certificate" "certificate" {
  account_key_pem           = "${acme_registration.reg.account_key_pem}"
  common_name               = "pcf.${local.base_domain}"
  subject_alternative_names = ["*.apps.${local.base_domain}", "*.sys.${local.base_domain}", "*.uaa.sys.${local.base_domain}", "*.login.sys.${local.base_domain}"]

  dns_challenge {
    provider = "azure"

    config = {
      AZURE_CLIENT_ID       = "${var.client_id}"
      AZURE_CLIENT_SECRET   = "${var.client_secret}"
      AZURE_SUBSCRIPTION_ID = "${var.subscription_id}"
      AZURE_TENANT_ID       = "${var.tenant_id}"
      AZURE_RESOURCE_GROUP  = "${module.azure.pcf_resource_group_name}"
    }
  }

  depends_on = ["azurerm_dns_ns_record.test"]
}

locals {
  cert_full_chain = "${acme_certificate.certificate.certificate_pem}${acme_certificate.certificate.issuer_pem}"
  cert_key        = "${acme_certificate.certificate.private_key_pem}"
}
