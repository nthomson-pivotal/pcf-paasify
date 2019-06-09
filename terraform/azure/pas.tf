# TODO: Enabled S3 encryption for filestore
data "template_file" "pas_product_configuration" {
  template = "${chomp(file("${path.module}/templates/pas_config_ops.yml"))}"

  vars {
    account_name          = "${module.azure.cf_storage_account_name}"
    access_key            = "${module.azure.cf_storage_account_access_key}"
    droplets_container    = "${module.azure.cf_droplets_storage_container}"
    packages_container    = "${module.azure.cf_packages_storage_container}"
    buildpacks_container  = "${module.azure.cf_buildpacks_storage_container}"
    resources_container   = "${module.azure.cf_resources_storage_container}"
  }
}