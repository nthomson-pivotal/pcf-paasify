# TODO: Enabled S3 encryption for filestore
data "template_file" "pas_product_configuration" {
  template = "${chomp(file("${path.module}/templates/pas_product_configuration.json"))}"

  vars {
    region    = "${var.region}"
    access_key = "${module.aws.ops_manager_iam_user_access_key}"
    secret_key    = "${module.aws.ops_manager_iam_user_secret_key}"
    droplets_bucket = "${module.aws.pas_droplets_bucket}"
    packages_bucket = "${module.aws.pas_packages_bucket}"
    buildpacks_bucket = "${module.aws.pas_buildpacks_bucket}"
    resources_bucket = "${module.aws.pas_resources_bucket}"
  }
}

data "template_file" "pas_resource_configuration" {
  template = "${chomp(file("${path.module}/templates/pas_resource_configuration.json"))}"

  vars {
    ssh_elb_name = "${module.aws.ssh_elb_name}"
    web_elb_name = "${module.aws.web_elb_name}"
  }
}