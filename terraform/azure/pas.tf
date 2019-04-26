# TODO: Enabled S3 encryption for filestore
data "template_file" "pas_product_configuration" {
  template = "${chomp(file("${path.module}/templates/pas_product_configuration.json"))}"

  vars {
    account_name          = "${module.azure.cf_storage_account_name}"
    access_key            = "${module.azure.cf_storage_account_access_key}"
    droplets_container    = "${module.azure.cf_droplets_storage_container}"
    packages_container    = "${module.azure.cf_packages_storage_container}"
    buildpacks_container  = "${module.azure.cf_buildpacks_storage_container}"
    resources_container   = "${module.azure.cf_resources_storage_container}"
  }
}

data "template_file" "pas_resource_configuration" {
  template = "${chomp(file("${path.module}/templates/pas_resource_configuration.json"))}"

  vars {
    ssh_lb_name       = "${module.azure.diego_ssh_lb_name}"
    web_lb_name       = "${module.azure.web_lb_name}"
    compute_instances = "${var.compute_instance_count}"
  }
}