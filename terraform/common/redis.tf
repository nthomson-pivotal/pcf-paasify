data "template_file" "redis_az_configuration" {
  template = "${chomp(file("${path.module}/templates/services_az.json"))}"

  vars {
    az1 = "${var.az1}"
    az2 = "${var.az2}"
    az3 = "${var.az3}"
  }
}

data "template_file" "redis_product_configuration" {
  template = "${chomp(file("${path.module}/templates/redis_config.json"))}"

  vars {
    az1 = "${var.az1}"
    az2 = "${var.az2}"
    az3 = "${var.az3}"
  }
}

resource "null_resource" "setup_redis" {
  depends_on = ["null_resource.setup_pas"]

  provisioner "remote-exec" {
    inline = ["install_tile ${var.opsman_user} ${local.opsman_password} p-redis 1.13.4 p-redis-1.13.4.pivotal ${var.iaas}"]
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/setup_redis.sh"

    environment {
      OM_DOMAIN           = "${var.opsman_host}"
      OM_USERNAME         = "${var.opsman_user}"
      OM_PASSWORD         = "${local.opsman_password}"
      PRODUCT_CONFIG      = "${data.template_file.redis_product_configuration.rendered}"
      AZ_CONFIG           = "${data.template_file.redis_az_configuration.rendered}"
      redis_RES_CONFIG = "${var.redis_resource_configuration}"
    }
  }

  count = "${contains(var.tiles, "redis")}"

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}
