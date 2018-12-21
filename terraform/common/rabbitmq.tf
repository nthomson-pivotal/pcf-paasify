data "template_file" "rabbitmq_product_configuration" {
  template = "${chomp(file("${path.module}/templates/rabbitmq_config.json"))}"

  vars {
    az_string = "${var.iaas == "azure" ? "\"null\"" : join(",", formatlist("\"%s\"", var.azs))}"
  }
}

resource "null_resource" "setup_rabbitmq" {
  depends_on = ["null_resource.setup_pas"]

  provisioner "remote-exec" {
    inline = ["install_tile ${var.opsman_user} ${local.opsman_password} p-rabbitmq ${lookup(var.tile_versions, "rabbit")} pivotal ${var.iaas}"]
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/setup_tile.sh"

    environment {
      OM_DOMAIN           = "${var.opsman_host}"
      OM_USERNAME         = "${var.opsman_user}"
      OM_PASSWORD         = "${local.opsman_password}"
      PRODUCT_NAME        = "p-rabbitmq"
      PRODUCT_CONFIG      = "${data.template_file.rabbitmq_product_configuration.rendered}"
      AZ_CONFIG           = "${data.template_file.tile_az_services_configuration.rendered}"
    }
  }

  count = "${contains(var.tiles, "rabbit") || contains(var.tiles, "scs") ? 1 : 0}"

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}
