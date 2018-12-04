resource "null_resource" "setup_metrics" {
  depends_on = ["null_resource.setup_pas"]

  provisioner "remote-exec" {
    inline = ["install_tile ${var.opsman_user} ${local.opsman_password} p-metrics-forwarder ${lookup(var.tile_versions, "metrics-forwarder")} pivotal ${var.iaas}",
      "install_tile ${var.opsman_user} ${local.opsman_password} apm ${lookup(var.tile_versions, "metrics")} pivotal ${var.iaas} apmPostgres",
    ]
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/setup_metrics.sh"

    environment {
      OM_DOMAIN                    = "${var.opsman_host}"
      OM_USERNAME                  = "${var.opsman_user}"
      OM_PASSWORD                  = "${local.opsman_password}"
      METRICS_AZ_CONFIG            = "${data.template_file.tile_az_services_configuration.rendered}"
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
