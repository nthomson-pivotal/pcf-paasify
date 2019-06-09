data "template_file" "rabbitmq_configuration" {
  template = "${chomp(file("${path.module}/templates/tiles/rabbitmq_config.yml"))}"

  vars {
    az1 = "${var.azs[0]}"
    az2 = "${var.azs[1]}"
    az3 = "${var.azs[2]}"
  }
}

resource "null_resource" "setup_rabbitmq" {
  depends_on = ["null_resource.setup_pas"]

  provisioner "remote-exec" {
    inline = ["install_tile p-rabbitmq ${lookup(var.tile_versions, "rabbit")} pivotal ${var.iaas}"]
  }

  provisioner "file" {
    content     = "${data.template_file.rabbitmq_configuration.rendered}"
    destination = "~/config/p-rabbitmq-config.yml"
  }

  provisioner "remote-exec" {
    inline = ["configure_tile p-rabbitmq"]
  }

  count = "${contains(var.tiles, "rabbit") || contains(var.tiles, "scs") ? 1 : 0}"

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}
