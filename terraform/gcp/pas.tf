data "template_file" "pas_product_configuration" {
  template = "${chomp(file("${path.module}/templates/pas_product_configuration.json"))}"

  vars {
    project    = "${module.gcp.pas_blobstore_service_account_project}"
    service_account_email = "${google_service_account.account.email}"
    service_account_key    = "${jsonencode(base64decode(google_service_account_key.key.private_key))}"
    droplets_bucket = "${module.gcp.droplets_bucket}"
    packages_bucket = "${module.gcp.packages_bucket}"
    buildpacks_bucket = "${module.gcp.buildpacks_bucket}"
    resources_bucket = "${module.gcp.resources_bucket}"
  }
}

data "template_file" "pas_resource_configuration" {
  template = "${chomp(file("${path.module}/templates/pas_resource_configuration.json"))}"

  vars {
    ssh_lb_name    = "${module.gcp.ssh_lb_name}"
    ws_router_pool = "${module.gcp.ws_router_pool}"
    web_lb_name    = "${module.gcp.http_lb_backend_name}"
  }
}