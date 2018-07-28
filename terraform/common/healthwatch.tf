data "template_file" "healthwatch_product_configuration" {
  template = "${chomp(file("${path.module}/templates/healthwatch_config.json"))}"

  vars {
    om_domain = "${var.opsman_host}"
    bosh_az   = "${var.az1}"
  }
}

data "template_file" "healthwatch_az_configuration" {
  template = "${chomp(file("${path.module}/templates/services_az.json"))}"

  vars {
    az1 = "${var.az1}"
    az2 = "${var.az2}"
    az3 = "${var.az3}"
  }
}

resource "null_resource" "setup_healthwatch" {
  depends_on = ["null_resource.setup_pas"]

  provisioner "remote-exec" {
    inline = ["install_tile ${var.opsman_user} ${local.opsman_password} p-healthwatch 1.1.8 p-healthwatch-1.1.8-build.1.pivotal"]
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/setup_healthwatch.sh"

    environment {
      OM_DOMAIN                  = "${var.opsman_host}"
      OM_USERNAME                = "${var.opsman_user}"
      OM_PASSWORD                = "${local.opsman_password}"
      HEALTHWATCH_AZ_CONFIG      = "${data.template_file.healthwatch_az_configuration.rendered}"
      HEALTHWATCH_PRODUCT_CONFIG = "${data.template_file.healthwatch_product_configuration.rendered}"
      HEALTHWATCH_RES_CONFIG     = "${var.healthwatch_resource_configuration}"
    }
  }

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }

  count = "${contains(var.tiles, "healthwatch") ? 1 : 0}"
}
