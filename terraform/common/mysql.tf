data "template_file" "mysql_product_configuration" {
  template = "${chomp(file("${path.module}/templates/mysql_config.json"))}"

  vars {
    az_string = "${var.iaas == "azure" ? "\"null\"" : join(",", formatlist("\"%s\"", var.azs))}"
  }
}

resource "null_resource" "setup_mysql" {
  depends_on = ["null_resource.setup_pas"]

  provisioner "remote-exec" {
    inline = ["install_tile pivotal-mysql ${lookup(var.tile_versions, "mysql")} .pivotal ${var.iaas}"]
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/setup_tile.sh"

    environment {
      OM_DOMAIN      = "${var.opsman_host}"
      OM_USERNAME    = "${var.opsman_user}"
      OM_PASSWORD    = "${local.opsman_password}"
      PRODUCT_NAME   = "pivotal-mysql"
      PRODUCT_CONFIG = "${data.template_file.mysql_product_configuration.rendered}"
      AZ_CONFIG      = "${data.template_file.tile_az_services_configuration.rendered}"
    }
  }

  count = "${contains(var.tiles, "mysql") || contains(var.tiles, "scs") ? 1 : 0}"

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}
