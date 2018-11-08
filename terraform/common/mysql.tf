data "template_file" "mysql_product_configuration" {
  template = "${chomp(file("${path.module}/templates/mysql_config.json"))}"

  vars {
    az_string = "${var.iaas == "azure" ? "\"null\"" : "\"${var.az1}\",\"${var.az2}\",\"${var.az3}\""}"

    backup_config = "${var.mysql_backup_configuration}"
  }
}

data "template_file" "mysql_az_configuration" {
  template = "${chomp(file("${path.module}/templates/services_az.json"))}"

  vars {
    az1 = "${var.az1}"
    az2 = "${var.az2}"
    az3 = "${var.az3}"
  }
}

resource "null_resource" "setup_mysql" {
  depends_on = ["null_resource.setup_pas"]

  provisioner "remote-exec" {
    inline = ["install_tile ${var.opsman_user} ${local.opsman_password} pivotal-mysql ${lookup(var.tile_versions, "mysql")} .pivotal ${var.iaas}"]
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/setup_tile.sh"

    environment {
      OM_DOMAIN      = "${var.opsman_host}"
      OM_USERNAME    = "${var.opsman_user}"
      OM_PASSWORD    = "${local.opsman_password}"
      PRODUCT_NAME   = "pivotal-mysql"
      PRODUCT_CONFIG = "${data.template_file.mysql_product_configuration.rendered}"
      AZ_CONFIG      = "${data.template_file.mysql_az_configuration.rendered}"
    }
  }

  count = "${contains(var.tiles, "mysql") || contains(var.tiles, "scs") ? 1 : 0}"

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}
