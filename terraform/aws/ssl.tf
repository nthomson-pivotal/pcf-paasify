provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"

  version = "~> 1.0"
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
  subject_alternative_names = ["*.apps.${local.base_domain}", "*.sys.${local.base_domain}", "*.uaa.sys.${local.base_domain}"]

  dns_challenge {
    provider = "route53"

    config = {
      AWS_HOSTED_ZONE_ID = "${module.aws.dns_zone_id}"
    }
  }
}

locals {
  cert_full_chain = "${acme_certificate.certificate.certificate_pem}${acme_certificate.certificate.issuer_pem}"
  cert_key        = "${acme_certificate.certificate.private_key_pem}"
}

output "tls_cert" {
  value = "${acme_certificate.certificate.certificate_pem}"
}

output "tls_key" {
  value = "${acme_certificate.certificate.private_key_pem}"
}
