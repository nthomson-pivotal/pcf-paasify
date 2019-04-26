data "template_file" "mysql_product_configuration" {
  template = "${chomp(file("${path.module}/templates/mysql_config.json"))}"

  vars {
    az_string = "${join(",", formatlist("\"%s\"", var.azs))}"
  }
}

resource "null_resource" "setup_mysql" {
  depends_on = ["null_resource.setup_pas"]

  provisioner "remote-exec" {
    inline = ["install_tile pivotal-mysql ${lookup(var.tile_versions, "mysql")} .pivotal ${var.iaas}"]
  }

  provisioner "file" {
    content     = "${data.template_file.mysql_product_configuration.rendered}"
    destination = "~/config/pivotal-mysql-config.json"
  }

  provisioner "remote-exec" {
    inline = ["configure_tile pivotal-mysql services"]
  }

  count = "${contains(var.tiles, "mysql") || contains(var.tiles, "scs") ? 1 : 0}"

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}
