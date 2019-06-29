data "template_file" "pcc_configuration" {
  template = "${chomp(file("${path.module}/templates/tiles/pcc_config.yml"))}"

  vars {
    az1 = "${var.azs[0]}"
    az2 = "${var.azs[1]}"
    az3 = "${var.azs[2]}"
  }
}

resource "null_resource" "setup_pcc" {
  depends_on = ["null_resource.setup_pas"]

  provisioner "remote-exec" {
    inline = ["wrap install_tile p-cloudcache ${lookup(var.tile_versions, "pcc")} pivotal ${var.iaas}"]
  }

  provisioner "file" {
    content     = "${data.template_file.pcc_configuration.rendered}"
    destination = "~/config/p-cloudcache-config.yml"
  }

  provisioner "remote-exec" {
    inline = ["wrap configure_tile p-cloudcache"]
  }

  count = "${contains(var.tiles, "pcc") ? 1 : 0}"

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}