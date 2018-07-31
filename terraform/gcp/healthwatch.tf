data "template_file" "healthwatch_resource_configuration" {
  template = "${chomp(file("${path.module}/templates/healthwatch_resource_configuration.json"))}"
}
