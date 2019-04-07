data "template_file" "redis_product_configuration" {
  template = "${chomp(file("${path.module}/templates/redis_config.json"))}"

  vars {
    az1 = "${var.azs[0]}"
  }
}

resource "null_resource" "setup_redis" {
  depends_on = ["null_resource.setup_pas"]

  provisioner "remote-exec" {
    inline = ["install_tile p-redis ${lookup(var.tile_versions, "redis")} pivotal ${var.iaas}"]
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/setup_tile.sh"

    environment {
      OM_DOMAIN           = "${var.opsman_host}"
      OM_USERNAME         = "${var.opsman_user}"
      OM_PASSWORD         = "${local.opsman_password}"
      PRODUCT_NAME        = "p-redis"
      PRODUCT_CONFIG      = "${data.template_file.redis_product_configuration.rendered}"
      AZ_CONFIG           = "${data.template_file.tile_az_services_configuration.rendered}"
    }
  }

  count = "${contains(var.tiles, "redis") ? 1 : 0}"

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}
