data "template_file" "scs_product_configuration" {
  template = "${chomp(file("${path.module}/templates/scs_config.json"))}"
}

resource "null_resource" "setup_scs" {
  depends_on = ["null_resource.setup_pas", "null_resource.setup_mysql", "null_resource.setup_rabbitmq"]

  provisioner "remote-exec" {
    inline = ["install_tile p-spring-cloud-services ${lookup(var.tile_versions, "scs")} pivotal ${var.iaas}"]
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/setup_tile.sh"

    environment {
      OM_DOMAIN          = "${var.opsman_host}"
      OM_USERNAME        = "${var.opsman_user}"
      OM_PASSWORD        = "${local.opsman_password}"
      PRODUCT_NAME       = "p-spring-cloud-services"
      PRODUCT_CONFIG     = "${data.template_file.scs_product_configuration.rendered}"
      AZ_CONFIG          = "${data.template_file.tile_az_configuration.rendered}"
    }
  }

  count = "${contains(var.tiles, "scs") ? 1 : 0}"

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}
