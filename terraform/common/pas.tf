data "template_file" "pas_configuration" {
  template = "${chomp(file("${path.module}/templates/pcf.json"))}"

  vars {
    apps_domain          = "${var.apps_domain}"
    sys_domain           = "${var.sys_domain}"
    poe_cert             = "${jsonencode(var.ssl_cert)}"
    poe_private_key      = "${jsonencode(var.ssl_private_key)}"
    uaa_cert             = "${jsonencode(var.ssl_cert)}"
    uaa_private_key      = "${jsonencode(var.ssl_private_key)}"
    logger_endpoint_port = "${var.logger_endpoint_port}"
  }
}

resource "null_resource" "setup_pas" {
  depends_on = ["null_resource.setup_opsman"]

  provisioner "remote-exec" {
    inline = ["install_tile ${var.opsman_user} ${local.opsman_password} elastic-runtime ${var.pas_version} srt ${var.iaas} cf"]
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/setup_pas.sh"

    environment {
      OM_DOMAIN         = "${var.opsman_host}"
      OM_USERNAME       = "${var.opsman_user}"
      OM_PASSWORD       = "${local.opsman_password}"
      PAS_CONFIG        = "${data.template_file.pas_configuration.rendered}"
      PAS_CUSTOM_CONFIG = "${var.pas_product_configuration}"
      PAS_AZ_CONFIG     = "${data.template_file.tile_az_configuration.rendered}"
      PAS_RES_CONFIG    = "${var.pas_resource_configuration}"
    }
  }

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}
