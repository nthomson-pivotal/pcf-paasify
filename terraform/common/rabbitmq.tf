data "template_file" "rabbitmq_az_configuration" {
  template = "${chomp(file("${path.module}/templates/services_az.json"))}"

  vars {
    az1 = "${var.az1}"
    az2 = "${var.az2}"
    az3 = "${var.az3}"
  }
}

data "template_file" "rabbitmq_product_configuration" {
  template = "${chomp(file("${path.module}/templates/rabbitmq_config.json"))}"

  vars {
    az1 = "${var.az1}"
    az2 = "${var.az2}"
    az3 = "${var.az3}"
  }
}

resource "null_resource" "setup_rabbitmq" {
  depends_on = ["null_resource.setup_pas"]

  provisioner "remote-exec" {
    inline = ["install_tile ${var.opsman_user} ${local.opsman_password} p-rabbitmq ${lookup(var.tile_versions, "rabbit")} pivotal ${var.iaas}"]
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/setup_rabbitmq.sh"

    environment {
      OM_DOMAIN           = "${var.opsman_host}"
      OM_USERNAME         = "${var.opsman_user}"
      OM_PASSWORD         = "${local.opsman_password}"
      PRODUCT_CONFIG      = "${data.template_file.rabbitmq_product_configuration.rendered}"
      AZ_CONFIG           = "${data.template_file.rabbitmq_az_configuration.rendered}"
      RABBITMQ_RES_CONFIG = "${var.rabbitmq_resource_configuration}"
    }
  }

  count = "${contains(var.tiles, "rabbit") || contains(var.tiles, "scs") ? 1 : 0}"

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}
