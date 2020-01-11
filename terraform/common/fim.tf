resource "null_resource" "setup_fim" {
  depends_on = ["null_resource.setup_pas"]

  provisioner "remote-exec" {
    inline = ["wrap install_tile p-fim-addon ${lookup(var.tile_versions, "fim")} pivotal ${var.iaas} p-fim"]
  }

  count = "${contains(var.tiles, "fim") ? 1 : 0}"

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}
