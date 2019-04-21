data "template_file" "healthwatch_product_configuration" {
  template = "${chomp(file("${path.module}/templates/healthwatch_config.json"))}"

  vars {
    om_domain = "${var.opsman_host}"
    bosh_az   = "${var.azs[0]}"
  }
}

resource "null_resource" "setup_healthwatch" {
  depends_on = ["null_resource.setup_pas"]

  provisioner "remote-exec" {
    inline = ["install_tile p-healthwatch ${lookup(var.tile_versions, "healthwatch")} pivotal ${var.iaas}"]
  }

  provisioner "file" {
    content     = "${data.template_file.healthwatch_product_configuration.rendered}"
    destination = "~/config/p-healthwatch-config.json"
  }

  provisioner "file" {
    content     = "${var.healthwatch_resource_configuration}"
    destination = "~/config/p-healthwatch-resources.json"
  }

  provisioner "remote-exec" {
    inline = ["configure_tile p-healthwatch services"]
  }

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }

  count = "${contains(var.tiles, "healthwatch") ? 1 : 0}"
}
