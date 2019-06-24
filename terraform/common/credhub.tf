data "template_file" "credhub_configuration" {
  template = "${chomp(file("${path.module}/templates/tiles/credhub_config.yml"))}"

  vars {
    az1 = "${var.azs[0]}"
    az2 = "${var.azs[1]}"
    az3 = "${var.azs[2]}"
  }
}

resource "null_resource" "setup_credhub" {
  depends_on = ["null_resource.setup_pas"]

  provisioner "remote-exec" {
    inline = ["install_tile credhub-service-broker ${lookup(var.tile_versions, "credhub")} pivotal ${var.iaas}"]
  }

  provisioner "file" {
    content     = "${data.template_file.credhub_configuration.rendered}"
    destination = "~/config/credhub-service-broker-config.yml"
  }

  provisioner "remote-exec" {
    inline = ["configure_tile credhub-service-broker"]
  }

  count = "${contains(var.tiles, "credhub") ? 1 : 0}"

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}
