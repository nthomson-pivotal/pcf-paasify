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

  provisioner "file" {
    content     = "${data.template_file.redis_product_configuration.rendered}"
    destination = "~/config/p-redis-config.json"
  }

  provisioner "remote-exec" {
    inline = ["configure_tile p-redis services"]
  }

  count = "${contains(var.tiles, "redis") ? 1 : 0}"

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}
