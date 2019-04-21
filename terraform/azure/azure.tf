provider "azurerm" {
  version = "~> 1.18"

  subscription_id = "${var.subscription_id}"
  tenant_id       = "${var.tenant_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
}

module "azure" {
  source = "github.com/pivotal-cf/terraforming-azure?ref=95d011a"

  subscription_id = "${var.subscription_id}"
  tenant_id       = "${var.tenant_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"

  env_name              = "${var.env_name}"
  env_short_name        = "${var.env_name}"
  location              = "${var.region}"
  dns_suffix            = "${var.dns_suffix}"
  ops_manager_image_uri = "https://opsmanagerwestus.blob.core.windows.net/images/ops-manager-2.4-build.117.vhd"

  ssl_cert        = "${local.cert_full_chain}"
  ssl_private_key = "${local.cert_key}"
}

locals {
  ssh_private_key_encoded = "${jsonencode(module.azure.ops_manager_ssh_private_key)}"
  ssh_public_key_encoded = "${jsonencode(module.azure.ops_manager_ssh_public_key)}"
}

resource "null_resource" "dependency_blocker" {
  depends_on = ["module.azure", "azurerm_dns_ns_record.test"]
}


module "common" {
  source = "../common"

  env_name = "${var.env_name}"
  iaas     = "azure"
  region   = "${var.region}"
  azs      = ["null"]

  ssl_cert                     = "${local.cert_full_chain}"
  ssl_private_key              = "${local.cert_key}"
  opsman_user                  = "${var.opsman_user}"
  opsman_ip                    = "${module.azure.ops_manager_ip}"
  opsman_host                  = "${module.azure.ops_manager_dns}"
  opsman_ssh_key               = "${module.azure.ops_manager_ssh_private_key}"
  opsman_configuration         = "${data.template_file.om_configuration.rendered}"

  bosh_director_ip             = "${cidrhost(module.azure.management_subnet_cidrs[0], 10)}"

  pivnet_token = "${var.pivnet_token}"

  pas_product_configuration  = "${data.template_file.pas_product_configuration.rendered}"
  pas_resource_configuration = "${data.template_file.pas_resource_configuration.rendered}"

  apps_domain = "${module.azure.apps_domain}"
  sys_domain  = "${module.azure.sys_domain}"

  opsman_id = "12345"

  tiles = "${var.tiles}"
  
  healthwatch_resource_configuration = "{}"

  metrics_resource_configuration           = "{}"
  metrics_forwarder_resource_configuration = "{}"

  prometheus_resource_configuration = "{}"

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