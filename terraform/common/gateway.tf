data "template_file" "gateway_configuration" {
  template = "${chomp(file("${path.module}/templates/tiles/gateway_config.yml"))}"

  vars {
    az1 = "${var.azs[0]}"
    az2 = "${var.azs[1]}"
    az3 = "${var.azs[2]}"
  }
}

resource "null_resource" "setup_gateway" {
  depends_on = ["null_resource.setup_pas"]

  provisioner "remote-exec" {
    inline = ["wrap install_tile spring-cloud-gateway ${lookup(var.tile_versions, "gateway")} pivotal ${var.iaas} p_spring-cloud-gateway-service"]
  }

  provisioner "file" {
    content     = "${data.template_file.gateway_configuration.rendered}"
    destination = "~/config/p_spring-cloud-gateway-service-config.yml"
  }

  provisioner "remote-exec" {
    inline = ["wrap configure_tile p_spring-cloud-gateway-service"]
  }

  count = "${contains(var.tiles, "gateway") ? 1 : 0}"

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}
