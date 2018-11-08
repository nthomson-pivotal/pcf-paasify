data "azurerm_dns_zone" "paasify" {
  name = "${var.dns_suffix}"
}

resource "azurerm_dns_ns_record" "test" {
  name                = "${var.env_name}"
  zone_name           = "${data.azurerm_dns_zone.paasify.name}"
  resource_group_name = "${data.azurerm_dns_zone.paasify.resource_group_name}"

  ttl = 300

  records = [
    "${module.azure.env_dns_zone_name_servers}",
  ]
}

locals {
  base_domain = "${var.env_name}.${var.dns_suffix}"
}