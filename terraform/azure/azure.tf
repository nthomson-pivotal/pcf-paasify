provider "azurerm" {
  version = "~> 1.31.0"

  subscription_id = "${var.subscription_id}"
  tenant_id       = "${var.tenant_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
}

data "azurerm_client_config" "current" {}

module "azure" {
  source = "github.com/pivotal-cf/terraforming-azure?ref=b224e8c//terraforming-pas"

  subscription_id = "${var.subscription_id}"
  tenant_id       = "${var.tenant_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"

  env_name              = "${var.env_name}"
  location              = "${var.region}"
  dns_suffix            = "${var.dns_suffix}"

  pcf_virtual_network_address_space = ["${var.vpc_cidr}"]
  pcf_infrastructure_subnet         = "${module.cidr_calculator.infrastructure_cidr}"
  pcf_pas_subnet                    = "${module.cidr_calculator.pas_cidr}"
  pcf_services_subnet               = "${module.cidr_calculator.services_cidr}"
  ops_manager_private_ip            = "${cidrhost(module.cidr_calculator.infrastructure_cidr, 4)}"

  ops_manager_image_uri = "https://opsmanagerwestus.blob.core.windows.net/images/ops-manager-${module.common.opsman_version}-build.${module.common.opsman_build}.vhd"

  ssl_cert        = "${local.cert_full_chain}"
  ssl_private_key = "${local.cert_key}"
}

locals {
  ssh_private_key_encoded = "${jsonencode(module.azure.ops_manager_ssh_private_key)}"
  ssh_public_key_encoded = "${jsonencode(module.azure.ops_manager_ssh_public_key)}"
}

resource "null_resource" "dependency_blocker" {
  depends_on = ["module.azure", "azurerm_dns_ns_record.test"]

  provisioner "local-exec" {
    command = "sleep 30"
  }
}

module "common" {
  source = "../common"

  env_name = "${var.env_name}"
  iaas     = "azure"
  region   = "${var.region}"
  azs      = ["zone-1", "zone-2", "zone-3"]

  ssl_cert                     = "${local.cert_full_chain}"
  ssl_private_key              = "${local.cert_key}"
  opsman_user                  = "${var.opsman_user}"
  opsman_password              = "${var.opsman_password}"
  opsman_ip                    = "${module.azure.ops_manager_ip}"
  opsman_host                  = "${module.azure.ops_manager_dns}"
  opsman_ssh_key               = "${module.azure.ops_manager_ssh_private_key}"
  opsman_configuration         = "${data.template_file.om_configuration.rendered}"

  bosh_director_ip             = "${cidrhost(module.azure.management_subnet_cidrs[0], 10)}"

  pivnet_token = "${var.pivnet_token}"

  pas_product_configuration  = "${data.template_file.pas_product_configuration.rendered}"

  apps_domain = "${module.azure.apps_domain}"
  sys_domain  = "${module.azure.sys_domain}"

  ssh_elb_name       = "${module.azure.diego_ssh_lb_name}"
  web_elb_names      = ["${module.azure.web_lb_name}"]
  compute_instances  = "${var.compute_instance_count}"

  opsman_id = "12345"

  tiles = "${var.tiles}"

  wavefront_token = "${var.wavefront_token}"

  dependency_blocker = "${null_resource.dependency_blocker.id}"
}

resource "null_resource" "apply_common" {
  depends_on = ["module.common"]

  provisioner "remote-exec" {
    inline = ["apply_changes"]
  }

  count = "${var.auto_apply == "1" ? 1 : 0}"

  connection {
    host        = "${module.azure.ops_manager_dns}"
    user        = "ubuntu"
    private_key = "${module.azure.ops_manager_ssh_private_key}"
  }
}