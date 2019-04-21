data "template_file" "scs_product_configuration" {
  template = "${chomp(file("${path.module}/templates/scs_config.json"))}"
}

resource "null_resource" "setup_scs" {
  depends_on = ["null_resource.setup_pas", "null_resource.setup_mysql", "null_resource.setup_rabbitmq"]

  provisioner "remote-exec" {
    inline = ["install_tile p-spring-cloud-services ${lookup(var.tile_versions, "scs")} pivotal ${var.iaas}"]
  }

  provisioner "file" {
    content     = "${data.template_file.scs_product_configuration.rendered}"
    destination = "~/config/p-spring-cloud-services-config.json"
  }

  provisioner "remote-exec" {
    inline = ["configure_tile p-spring-cloud-services noservices"]
  }

  count = "${contains(var.tiles, "scs") ? 1 : 0}"

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}
