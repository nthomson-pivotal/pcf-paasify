data "template_file" "scs_configuration" {
  template = "${chomp(file("${path.module}/templates/tiles/scs_config.yml"))}"

  vars {
    az1 = "${var.azs[0]}"
    az2 = "${var.azs[1]}"
    az3 = "${var.azs[2]}"
  }
}

resource "null_resource" "setup_scs" {
  depends_on = ["null_resource.setup_pas", "null_resource.setup_mysql", "null_resource.setup_rabbitmq"]

  provisioner "remote-exec" {
    inline = ["install_tile p-spring-cloud-services ${lookup(var.tile_versions, "scs")} pivotal ${var.iaas}"]
  }

  provisioner "file" {
    content     = "${data.template_file.scs_configuration.rendered}"
    destination = "~/config/p-spring-cloud-services-config.yml"
  }

  provisioner "remote-exec" {
    inline = ["configure_tile p-spring-cloud-services"]
  }

  count = "${contains(var.tiles, "scs") ? 1 : 0}"

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}
