data "template_file" "scs3_configuration" {
  template = "${chomp(file("${path.module}/templates/tiles/scs3_config.yml"))}"

  vars {
    az1 = "${var.azs[0]}"
    az2 = "${var.azs[1]}"
    az3 = "${var.azs[2]}"
  }
}

resource "null_resource" "setup_scs3" {
  depends_on = ["null_resource.setup_pas"]

  provisioner "remote-exec" {
    inline = ["wrap install_tile p-spring-cloud-services ${lookup(var.tile_versions, "scs3")} pivotal ${var.iaas} p_spring-cloud-services"]
  }

  provisioner "file" {
    content     = "${data.template_file.scs3_configuration.rendered}"
    destination = "~/config/p_spring-cloud-services-config.yml"
  }

  provisioner "remote-exec" {
    inline = ["wrap configure_tile p_spring-cloud-services"]
  }

  count = "${contains(var.tiles, "scs3") ? 1 : 0}"

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}
