data "template_file" "antivirus_configuration" {
  template = "${chomp(file("${path.module}/templates/tiles/antivirus_config.yml"))}"

  vars {
    az1 = "${var.azs[0]}"
    az2 = "${var.azs[1]}"
    az3 = "${var.azs[2]}"
  }
}

resource "null_resource" "setup_antivirus" {
  depends_on = ["null_resource.setup_pas"]

  provisioner "remote-exec" {
    inline = ["wrap install_tile p-clamav-addon ${lookup(var.tile_versions, "antivirus")} p-antivirus-${lookup(var.tile_versions, "antivirus")} ${var.iaas} p-antivirus"]
  }

  provisioner "file" {
    content     = "${data.template_file.antivirus_configuration.rendered}"
    destination = "~/config/p-antivirus-config.yml"
  }

  provisioner "remote-exec" {
    inline = ["wrap configure_tile p-antivirus"]
  }

  count = "${contains(var.tiles, "antivirus") ? 1 : 0}"

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}
