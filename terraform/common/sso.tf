data "template_file" "sso_configuration" {
  template = "${chomp(file("${path.module}/templates/tiles/sso_config.yml"))}"

  vars {
    az1 = "${var.azs[0]}"
    az2 = "${var.azs[1]}"
    az3 = "${var.azs[2]}"
  }
}

resource "null_resource" "setup_sso" {
  depends_on = ["null_resource.setup_pas"]

  provisioner "remote-exec" {
    inline = ["wrap install_tile pivotal_single_sign-on_service ${lookup(var.tile_versions, "sso")} Pivotal ${var.iaas} Pivotal_Single_Sign-On_Service"]
  }

  provisioner "file" {
    content     = "${data.template_file.sso_configuration.rendered}"
    destination = "~/config/Pivotal_Single_Sign-On_Service-config.yml"
  }

  provisioner "remote-exec" {
    inline = ["wrap configure_tile Pivotal_Single_Sign-On_Service"]
  }

  count = "${contains(var.tiles, "sso") ? 1 : 0}"

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}
