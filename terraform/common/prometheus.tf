data "template_file" "prometheus_product_configuration" {
  template = "${chomp(file("${path.module}/templates/prometheus_config.json"))}"
}

resource "null_resource" "setup_prometheus" {
  depends_on = ["null_resource.setup_pas"]

  provisioner "remote-exec" {
    inline = ["install_raw_tile prometheus-dev 0.0.1 ${var.iaas} https://storage.googleapis.com/prometheus-tile-dev/prometheus-0.0.1.pivotal"]
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
