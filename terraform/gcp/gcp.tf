provider "google" {
  region  = "${var.region}"
  project = "${var.project}"
}

module "gcp" {
  source = "github.com/nthomson-pivotal/terraforming-gcp?ref=fcc7c8//terraforming-pas"

  project = "${var.project}"

  service_account_key = "${base64decode(google_service_account_key.key.private_key)}"
  env_name            = "${var.env_name}"
  region              = "${var.region}"
  buckets_location    = "${var.buckets_location}"
  dns_suffix          = "${var.dns_suffix}"
  opsman_image_url    = "https://storage.googleapis.com/ops-manager-us/pcf-gcp-${module.common.opsman_version}-build.${module.common.opsman_build}.tar.gz"
  zones               = ["${lookup(var.az1, var.region)}", "${lookup(var.az2, var.region)}", "${lookup(var.az3, var.region)}"]
  ssl_cert            = "${local.cert_full_chain}"
  ssl_private_key     = "${local.cert_key}"

  # Breaks if you don't do this....
  iso_seg_ssl_cert    = "${local.cert_full_chain}"
  iso_seg_ssl_private_key    = "${local.cert_key}"
}

resource "null_resource" "dependency_blocker" {
  depends_on = ["module.gcp", "google_compute_router_nat.nat", "google_dns_record_set.ns"]
}

# Use intermediate local to hold JSON encoded SSH key
locals {
  ssh_private_key_encoded = "${jsonencode(module.gcp.ops_manager_ssh_private_key)}"
}

module "common" {
  source = "../common"

  env_name                     = "${var.env_name}"
  iaas                         = "google"
  region                       = "${var.region}"
  azs                          = ["${lookup(var.az1, var.region)}", "${lookup(var.az2, var.region)}", "${lookup(var.az3, var.region)}"]

  ssl_cert                     = "${local.cert_full_chain}"
  ssl_private_key              = "${local.cert_key}"
  opsman_user                  = "${var.opsman_user}"
  opsman_password              = "${var.opsman_password}"
  opsman_ip                    = "${module.gcp.ops_manager_ip}"
  opsman_host                  = "${module.gcp.ops_manager_dns}"
  opsman_ssh_key               = "${module.gcp.ops_manager_ssh_private_key}"
  opsman_configuration         = "${data.template_file.om_configuration.rendered}"

  bosh_director_ip             = "${cidrhost(module.gcp.management_subnet_cidrs[0], 10)}"

  pivnet_token = "${var.pivnet_token}"

  pas_product_configuration = "${data.template_file.pas_product_configuration.rendered}"

  apps_domain = "${module.gcp.apps_domain}"
  sys_domain  = "${module.gcp.sys_domain}"

  ssh_elb_name      = "\"tcp:${module.gcp.ssh_lb_name}\""
  web_elb_names     = ["\"tcp:${module.gcp.ws_router_pool}\"", "\"http:${module.gcp.http_lb_backend_name}\""]
  compute_instances = "${var.compute_instance_count}"

  opsman_id = "1234"

  tiles = "${var.tiles}"

  healthwatch_mysql_instance_type     = "xlarge"
  healthwatch_forwarder_instance_type = "large"

  metrics_mysql_instance_type         = "large"
  metrics_postgres_instance_type      = "automatic"

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
    host        = "${module.gcp.ops_manager_dns}"
    user        = "ubuntu"
    private_key = "${module.gcp.ops_manager_ssh_private_key}"
  }
}
