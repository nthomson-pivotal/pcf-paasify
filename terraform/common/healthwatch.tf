data "template_file" "healthwatch_product_configuration" {
  template = "${chomp(file("${path.module}/templates/healthwatch_config.json"))}"

  vars {
    om_domain = "${var.opsman_host}"
    bosh_az   = "${var.azs[0]}"
  }
}

resource "null_resource" "setup_healthwatch" {
  depends_on = ["null_resource.setup_pas"]

  provisioner "remote-exec" {
    inline = ["install_tile ${var.opsman_user} ${local.opsman_password} p-healthwatch ${lookup(var.tile_versions, "healthwatch")} pivotal ${var.iaas}"]
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/setup_tile.sh "

    environment {
      OM_DOMAIN      = "${var.opsman_host}"
      OM_USERNAME    = "${var.opsman_user}"
      OM_PASSWORD    = "${local.opsman_password}"

      PRODUCT_NAME   = "p-healthwatch"
      PRODUCT_CONFIG = "${data.template_file.healthwatch_product_configuration.rendered}"
      AZ_CONFIG      = "${data.template_file.tile_az_services_configuration.rendered}"
      RESOURCE_CONFIG = "${var.healthwatch_resource_configuration}"
    }
  }

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }

  count = "${contains(var.tiles, "healthwatch") ? 1 : 0}"
}
