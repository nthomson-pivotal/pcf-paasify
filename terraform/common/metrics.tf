data "template_file" "metrics_az_configuration" {
  template = "${chomp(file("${path.module}/templates/services_az.json"))}"

  vars {
    az1 = "${var.az1}"
    az2 = "${var.az2}"
    az3 = "${var.az3}"
  }
}

resource "null_resource" "setup_metrics" {
  depends_on = ["null_resource.setup_pas"]

  provisioner "remote-exec" {
    inline = ["install_tile ${var.opsman_user} ${local.opsman_password} p-metrics-forwarder 1.11.2 p-metrics-forwarder-1.11.2.pivotal ${var.iaas}",
      "install_tile ${var.opsman_user} ${local.opsman_password} apm 1.4.5 apm-1.4.5.pivotal ${var.iaas}",
    ]
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/setup_metrics.sh"

    environment {
      OM_DOMAIN                    = "${var.opsman_host}"
      OM_USERNAME                  = "${var.opsman_user}"
      OM_PASSWORD                  = "${local.opsman_password}"
      METRICS_AZ_CONFIG            = "${data.template_file.metrics_az_configuration.rendered}"
      METRICS_RES_CONFIG           = "${var.metrics_resource_configuration}"
      METRICS_FORWARDER_RES_CONFIG = "${var.metrics_forwarder_resource_configuration}"
    }
  }

  count = "${contains(var.tiles, "metrics") ? 1 : 0}"

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}
