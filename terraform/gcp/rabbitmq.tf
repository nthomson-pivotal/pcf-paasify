data "template_file" "rabbitmq_resource_configuration" {
  template = "${chomp(file("${path.module}/templates/rabbitmq_resource_configuration.json"))}"
}
