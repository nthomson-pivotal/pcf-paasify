locals {
  base_domain = "${var.env_name}.${var.dns_suffix}"
}

resource "google_dns_record_set" "ns" {
  managed_zone = "${var.dns_zone_name}"
  name         = "${local.base_domain}."
  type         = "NS"
  ttl          = "30"

  rrdatas = [
    "${module.gcp.env_dns_zone_name_servers[0]}",
  ]
}