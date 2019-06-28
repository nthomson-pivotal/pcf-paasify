data "template_file" "mysql_configuration" {
  template = "${chomp(file("${path.module}/templates/tiles/mysql_config.yml"))}"

  vars {
    az1 = "${var.azs[0]}"
    az2 = "${var.azs[1]}"
    az3 = "${var.azs[2]}"
  }
}

resource "null_resource" "setup_mysql" {
  depends_on = ["null_resource.setup_pas"]

  provisioner "remote-exec" {
    inline = ["wrap install_tile pivotal-mysql ${lookup(var.tile_versions, "mysql")} .pivotal ${var.iaas}"]
  }

  provisioner "file" {
    content     = "${data.template_file.mysql_configuration.rendered}"
    destination = "~/config/pivotal-mysql-config.yml"
  }

  provisioner "remote-exec" {
    inline = ["wrap configure_tile pivotal-mysql"]
  }

  count = "${contains(var.tiles, "mysql") || contains(var.tiles, "scs") ? 1 : 0}"

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}
