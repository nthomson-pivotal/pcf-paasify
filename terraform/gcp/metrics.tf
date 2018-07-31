data "template_file" "metrics_resource_configuration" {
  template = "${chomp(file("${path.module}/templates/metrics_resource_configuration.json"))}"
}

data "template_file" "metrics_forwarder_resource_configuration" {
  template = "${chomp(file("${path.module}/templates/metrics_forwarder_resource_configuration.json"))}"
}
