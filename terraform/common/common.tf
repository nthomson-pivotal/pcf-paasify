data "template_file" "tile_az_configuration" {
  template = "${chomp(file("${path.module}/templates/pas_az.json"))}"

  vars {
    az1 = "${var.azs[0]}"
    az_string = "${join(",", formatlist("{\"name\":\"%s\"}", var.azs))}"
  }
}

data "template_file" "tile_az_services_configuration" {
  template = "${chomp(file("${path.module}/templates/services_az.json"))}"

  vars {
    az1 = "${var.azs[0]}"
    az_string = "${join(",", formatlist("{\"name\":\"%s\"}", var.azs))}"
  }
}