data "template_file" "prometheus_resource_configuration" {
  template = "${chomp(file("${path.module}/templates/prometheus_resource_configuration.json"))}"
}