locals {
  base_domain = "${var.env_name}.${var.dns_suffix}"
}

data "aws_route53_zone" "selected" {
  name = "${var.dns_suffix}."
}

resource "aws_route53_record" "ns" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "${local.base_domain}"
  type    = "NS"
  ttl     = "30"

  records = [
    "${module.aws.env_dns_zone_name_servers}",
  ]
}