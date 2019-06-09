data "template_file" "healthwatch_configuration" {
  template = "${chomp(file("${path.module}/templates/tiles/healthwatch_config.yml"))}"

  vars {
    az1                     = "${var.azs[0]}"
    az2                     = "${var.azs[1]}"
    az3                     = "${var.azs[2]}"
    mysql_instance_type     = "${var.healthwatch_mysql_instance_type}"
    forwarder_instance_type = "${var.healthwatch_forwarder_instance_type}"
    om_domain               = "${var.opsman_host}"
    bosh_az                 = "${var.azs[0]}"
  }
}

resource "null_resource" "setup_healthwatch" {
  depends_on = ["null_resource.setup_pas"]

  provisioner "remote-exec" {
    inline = ["install_tile p-healthwatch ${lookup(var.tile_versions, "healthwatch")} pivotal ${var.iaas}"]
  }

  provisioner "file" {
    content     = "${data.template_file.healthwatch_configuration.rendered}"
    destination = "~/config/p-healthwatch-config.yml"
  }

  provisioner "remote-exec" {
    inline = ["configure_tile p-healthwatch"]
  }

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }

  count = "${contains(var.tiles, "healthwatch") ? 1 : 0}"
}
