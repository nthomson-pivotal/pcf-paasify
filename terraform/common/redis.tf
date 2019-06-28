data "template_file" "redis_configuration" {
  template = "${chomp(file("${path.module}/templates/tiles/redis_config.yml"))}"

  vars {
    az1 = "${var.azs[0]}"
    az2 = "${var.azs[1]}"
    az3 = "${var.azs[2]}"
  }
}

resource "null_resource" "setup_redis" {
  depends_on = ["null_resource.setup_pas"]

  provisioner "remote-exec" {
    inline = ["wrap install_tile p-redis ${lookup(var.tile_versions, "redis")} pivotal ${var.iaas}"]
  }

  provisioner "file" {
    content     = "${data.template_file.redis_configuration.rendered}"
    destination = "~/config/p-redis-config.yml"
  }

  provisioner "remote-exec" {
    inline = ["wrap configure_tile p-redis"]
  }

  count = "${contains(var.tiles, "redis") ? 1 : 0}"

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}
