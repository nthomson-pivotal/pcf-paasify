data "template_file" "scs_product_configuration" {
  template = "${chomp(file("${path.module}/templates/scs_config.json"))}"
}

data "template_file" "scs_az_configuration" {
  template = "${chomp(file("${path.module}/templates/pas_az.json"))}"

  vars {
    az1 = "${var.az1}"
    az2 = "${var.az2}"
    az3 = "${var.az3}"
  }
}

resource "null_resource" "setup_scs" {
  depends_on = ["null_resource.setup_pas", "null_resource.setup_mysql", "null_resource.setup_rabbitmq"]

  provisioner "remote-exec" {
    inline = ["install_tile ${var.opsman_user} ${local.opsman_password} p-spring-cloud-services 1.5.2 p-spring-cloud-services-1.5.2.pivotal ${var.iaas}"]
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/setup_scs.sh"

    environment {
      OM_DOMAIN          = "${var.opsman_host}"
      OM_USERNAME        = "${var.opsman_user}"
      OM_PASSWORD        = "${local.opsman_password}"
      SCS_PRODUCT_CONFIG = "${data.template_file.scs_product_configuration.rendered}"
      AZ_CONFIG          = "${data.template_file.scs_az_configuration.rendered}"
    }
  }

  count = "${contains(var.tiles, "scs") ? 1 : 0}"

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}
