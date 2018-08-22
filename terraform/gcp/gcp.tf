provider "google" {
  region  = "${var.region}"
  project = "${var.project}"

  version = ">= 1.7.0"
}

module "gcp" {
  source = "github.com/nthomson-pivotal/terraforming-gcp"

  project = "${var.project}"

  service_account_key = "${base64decode(google_service_account_key.key.private_key)}"
  env_name            = "${var.env_name}"
  region              = "${var.region}"
  dns_suffix          = "${var.dns_suffix}"
  opsman_image_url    = "${var.opsman_image_url}"
  zones               = ["${lookup(var.az1, var.region)}", "${lookup(var.az2, var.region)}", "${lookup(var.az3, var.region)}"]
  ssl_cert            = "${local.cert_full_chain}"
  ssl_private_key     = "${local.cert_key}"
}

locals {
  base_domain = "${var.env_name}.${var.dns_suffix}"
}

resource "google_dns_record_set" "ns" {
  managed_zone = "${var.dns_zone_name}"
  name         = "${local.base_domain}."
  type         = "NS"
  ttl          = "300"

  rrdatas = [
    "${module.gcp.env_dns_zone_name_servers[0]}",
  ]
}

# Use intermediate local to hold JSON encoded SSH key
locals {
  ssh_private_key_encoded = "${jsonencode(module.gcp.ops_manager_ssh_private_key)}"
}

data "template_file" "iaas_configuration" {
  template = "${chomp(file("${path.module}/templates/iaas_configuration.json"))}"

  vars {
    project = "${var.project}"
  }
}

data "template_file" "pas_resource_configuration" {
  template = "${chomp(file("${path.module}/templates/pas_resource_configuration.json"))}"

  vars {
    ssh_lb_name    = "${module.gcp.ssh_lb_name}"
    ws_router_pool = "${module.gcp.ws_router_pool}"
    web_lb_name    = "${module.gcp.http_lb_backend_name}"
  }
}

module "common" {
  source = "../common"

  env_name                     = "${var.env_name}"
  iaas                         = "google"
  region                       = "${var.region}"
  az1                          = "${lookup(var.az1, var.region)}"
  az2                          = "${lookup(var.az2, var.region)}"
  az3                          = "${lookup(var.az3, var.region)}"
  ssl_cert                     = "${local.cert_full_chain}"
  ssl_private_key              = "${local.cert_key}"
  opsman_user                  = "${var.opsman_user}"
  opsman_ip                    = "${module.gcp.ops_manager_ip}"
  opsman_host                  = "${module.gcp.ops_manager_dns}"
  opsman_ssh_key               = "${module.gcp.ops_manager_ssh_private_key}"
  opsman_iaas_configuration    = "${data.template_file.iaas_configuration.rendered}"
  opsman_network_configuration = "${data.template_file.network_configuration.rendered}"

  pivnet_token = "${var.pivnet_token}"

  pas_resource_configuration = "${data.template_file.pas_resource_configuration.rendered}"

  apps_domain = "${module.gcp.apps_domain}"
  sys_domain  = "${module.gcp.sys_domain}"

  opsman_id  = "${module.gcp.ops_manager_instance_id}"
  ns_blocker = "${google_dns_record_set.ns.name}"

  tiles = "${var.tiles}"

  mysql_backup_configuration = "${data.template_file.mysql_backup_configuration.rendered}"

  rabbitmq_resource_configuration = "${data.template_file.rabbitmq_resource_configuration.rendered}"

  healthwatch_resource_configuration = "${data.template_file.healthwatch_resource_configuration.rendered}"

  metrics_resource_configuration           = "${data.template_file.metrics_resource_configuration.rendered}"
  metrics_forwarder_resource_configuration = "${data.template_file.metrics_forwarder_resource_configuration.rendered}"

  wavefront_token = "${var.wavefront_token}"
}
