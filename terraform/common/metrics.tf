resource "null_resource" "setup_metrics" {
  depends_on = ["null_resource.setup_pas"]

  provisioner "remote-exec" {
    inline = ["install_tile apm ${lookup(var.tile_versions, "metrics")} pivotal ${var.iaas} apmPostgres",
    ]
  }

  provisioner "file" {
    content     = "${var.metrics_resource_configuration}"
    destination = "~/config/apmPostgres-resources.json"
  }

  provisioner "remote-exec" {
    inline = ["configure_tile apmPostgres services"]
  }

  count = "${contains(var.tiles, "metrics") ? 1 : 0}"

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}
