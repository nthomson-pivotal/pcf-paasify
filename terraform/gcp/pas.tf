data "template_file" "pas_product_configuration" {
  template = "${chomp(file("${path.module}/templates/pas_config_ops.yml"))}"

  vars {
    project               = "${module.gcp.pas_blobstore_service_account_project}"
    service_account_email = "${google_service_account.account.email}"
    service_account_key   = "${jsonencode(base64decode(google_service_account_key.key.private_key))}"
    droplets_bucket       = "${module.gcp.droplets_bucket}"
    packages_bucket       = "${module.gcp.packages_bucket}"
    buildpacks_bucket     = "${module.gcp.buildpacks_bucket}"
    resources_bucket      = "${module.gcp.resources_bucket}"
    backup_bucket         = "${google_storage_bucket.backup.name}"
  }
}