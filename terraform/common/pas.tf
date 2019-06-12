data "template_file" "pas_configuration" {
  template = "${file("${path.module}/templates/tiles/pas_config.yml")}"

  vars {
    az1                  = "${var.azs[0]}"
    az2                  = "${var.azs[1]}"
    az3                  = "${var.azs[2]}"
    ssh_elb_name         = "${var.ssh_elb_name}"
    web_elb_names        = "${join(", ", var.web_elb_names)}"
    compute_instances    = "${var.compute_instances}"
    apps_domain          = "${var.apps_domain}"
    sys_domain           = "${var.sys_domain}"
    poe_cert             = "${jsonencode(var.ssl_cert)}"
    poe_private_key      = "${jsonencode(var.ssl_private_key)}"
    uaa_cert             = "${jsonencode(var.ssl_cert)}"
    uaa_private_key      = "${jsonencode(var.ssl_private_key)}"
    logger_endpoint_port = "${var.logger_endpoint_port}"
  }
}

resource "null_resource" "stage_pas" {

  depends_on = ["null_resource.provision_opsman"]

  provisioner "remote-exec" {
    inline = ["NO_STAGE=1 install_tile elastic-runtime ${var.pas_version} srt ${var.iaas} cf"]
  }

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}

resource "null_resource" "setup_pas" {
  depends_on = ["null_resource.setup_opsman", "null_resource.stage_pas"]

  provisioner "file" {
    content     = "${data.template_file.pas_configuration.rendered}"
    destination = "~/config/cf-config.yml"
  }

  provisioner "file" {
    content     = "${var.pas_product_configuration}"
    destination = "~/config/cf-config-ops.yml"
  }

  provisioner "remote-exec" {
    inline = ["install_tile elastic-runtime ${var.pas_version} srt ${var.iaas} cf"]
  }

  provisioner "remote-exec" {
    inline = ["configure_tile cf"]
  }

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}
