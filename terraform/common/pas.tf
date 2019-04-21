data "template_file" "pas_configuration" {
  template = "${chomp(file("${path.module}/templates/pcf.json"))}"

  vars {
    apps_domain          = "${var.apps_domain}"
    sys_domain           = "${var.sys_domain}"
    poe_cert             = "${jsonencode(var.ssl_cert)}"
    poe_private_key      = "${jsonencode(var.ssl_private_key)}"
    uaa_cert             = "${jsonencode(var.ssl_cert)}"
    uaa_private_key      = "${jsonencode(var.ssl_private_key)}"
    logger_endpoint_port = "${var.logger_endpoint_port}"
    additional_config    = "${var.pas_product_configuration}"
  }
}

resource "null_resource" "setup_pas" {
  depends_on = ["null_resource.setup_opsman"]

  provisioner "file" {
    content     = "${data.template_file.pas_configuration.rendered}"
    destination = "~/config/cf-config.json"
  }

  provisioner "file" {
    content     = "${var.pas_resource_configuration}"
    destination = "~/config/cf-resources.json"
  }

  provisioner "remote-exec" {
    inline = ["install_tile elastic-runtime ${var.pas_version} srt ${var.iaas} cf"]
  }

  provisioner "remote-exec" {
    inline = ["configure_tile cf noservices"]
  }

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}
