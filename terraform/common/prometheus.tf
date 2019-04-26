data "template_file" "prometheus_product_configuration" {
  template = "${chomp(file("${path.module}/templates/prometheus_config.json"))}"
}

resource "null_resource" "setup_prometheus" {
  depends_on = ["null_resource.setup_pas"]

  provisioner "remote-exec" {
    inline = ["install_raw_tile prometheus-dev ${lookup(var.tile_versions, "prometheus")} ${var.iaas} https://storage.googleapis.com/prometheus-tile-dev/prometheus-${lookup(var.tile_versions, "prometheus")}.pivotal",
    "install_stemcell stemcells 3541.98 ${var.iaas}"]
  }

  provisioner "file" {
    content     = "${data.template_file.prometheus_product_configuration.rendered}"
    destination = "~/config/prometheus-dev-config.json"
  }

  provisioner "file" {
    content     = "${var.prometheus_resource_configuration}"
    destination = "~/config/prometheus-dev-resources.json"
  }

  provisioner "remote-exec" {
    inline = ["configure_tile prometheus-dev noservices"]
  }

  count = "${contains(var.tiles, "prometheus") ? 1 : 0}"

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}
