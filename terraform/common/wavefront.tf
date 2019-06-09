data "template_file" "wavefront_product_configuration" {
  template = "${chomp(file("${path.module}/templates/wavefront_config.json"))}"

  vars {
    sys_domain      = "${var.sys_domain}"
    env_name        = "${var.env_name}"
    wavefront_token = "${var.wavefront_token}"
  }
}

resource "null_resource" "setup_wavefront" {
  depends_on = ["null_resource.setup_pas"]

  provisioner "remote-exec" {
    inline = ["install_tile wavefront-nozzle ${lookup(var.tile_versions, "wavefront")} pivotal ${var.iaas}"]
  }

  provisioner "file" {
    content     = "${data.template_file.wavefront_product_configuration.rendered}"
    destination = "~/config/wavefront-nozzle-config.json"
  }

  provisioner "remote-exec" {
    inline = ["configure_tile wavefront-nozzle noservices"]
  }

  count = "${contains(var.tiles, "wavefront") ? 1 : 0}"

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}
