data "template_file" "metrics_configuration" {
  template = "${file("${path.module}/templates/tiles/metrics_config.yml")}"

  vars {
    az1                     = "${var.azs[0]}"
    az2                     = "${var.azs[1]}"
    az3                     = "${var.azs[2]}"
    mysql_instance_type     = "${var.metrics_mysql_instance_type}"
    postgres_instance_type  = "${var.metrics_postgres_instance_type}"
  }
}

resource "null_resource" "setup_metrics" {
  depends_on = ["null_resource.setup_pas"]

  provisioner "remote-exec" {
    inline = ["wrap install_tile apm ${lookup(var.tile_versions, "metrics")} pivotal ${var.iaas} apmPostgres"]
  }

  provisioner "file" {
    content     = "${data.template_file.metrics_configuration.rendered}"
    destination = "~/config/apmPostgres-config.yml"
  }

  provisioner "remote-exec" {
    inline = ["wrap configure_tile apmPostgres"]
  }

  count = "${contains(var.tiles, "metrics") ? 1 : 0}"

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}
