data "template_file" "rabbitmq_product_configuration" {
  template = "${chomp(file("${path.module}/templates/rabbitmq_config.json"))}"

  vars {
    az_string = "${var.iaas == "azure" ? "\"null\"" : join(",", formatlist("\"%s\"", var.azs))}"
  }
}

resource "null_resource" "setup_rabbitmq" {
  depends_on = ["null_resource.setup_pas"]

  provisioner "remote-exec" {
    inline = ["install_tile p-rabbitmq ${lookup(var.tile_versions, "rabbit")} pivotal ${var.iaas}"]
  }

  provisioner "file" {
    content     = "${data.template_file.rabbitmq_product_configuration.rendered}"
    destination = "~/config/p-rabbitmq-config.json"
  }

  provisioner "remote-exec" {
    inline = ["configure_tile p-rabbitmq services"]
  }

  count = "${contains(var.tiles, "rabbit") || contains(var.tiles, "scs") ? 1 : 0}"

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}
