data "template_file" "scdf_configuration" {
  template = "${chomp(file("${path.module}/templates/tiles/scdf_config.yml"))}"

  vars {
    az1 = "${var.azs[0]}"
    az2 = "${var.azs[1]}"
    az3 = "${var.azs[2]}"
  }
}

resource "null_resource" "setup_scdf" {
  depends_on = ["null_resource.setup_pas", "null_resource.setup_mysql", "null_resource.setup_rabbitmq"]

  provisioner "remote-exec" {
    inline = ["wrap install_tile p-dataflow ${lookup(var.tile_versions, "scdf")} pivotal ${var.iaas}"]
  }

  provisioner "file" {
    content     = "${data.template_file.scdf_configuration.rendered}"
    destination = "~/config/p-dataflow-config.yml"
  }

  provisioner "remote-exec" {
    inline = ["wrap configure_tile p-dataflow"]
  }

  count = "${contains(var.tiles, "scdf") ? 1 : 0}"

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}
