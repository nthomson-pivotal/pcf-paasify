provider "aws" {
  region = "${var.region}"
}

data "aws_caller_identity" "current" {}

data "aws_ami" "om_ami" {
  most_recent      = true

  filter {
    name   = "name"
    values = ["pivotal-ops-manager-v${module.common.opsman_version}-build.${module.common.opsman_build}"]
  }
}

module "aws" {
  source = "github.com/pivotal-cf/terraforming-aws?ref=3f77c15//terraforming-pas"

  access_key         = "${aws_iam_access_key.key.id}"
  secret_key         = "${aws_iam_access_key.key.secret}"
  env_name           = "${var.env_name}"
  region             = "${var.region}"
  dns_suffix         = "${var.dns_suffix}"
  ops_manager_ami    = "${data.aws_ami.om_ami.image_id}"
  availability_zones = ["${lookup(var.az1, var.region)}", "${lookup(var.az2, var.region)}", "${lookup(var.az3, var.region)}"]
  ssl_cert           = "${local.cert_full_chain}"
  ssl_private_key    = "${local.cert_key}"
  vpc_cidr           = "${var.vpc_cidr}"
}

resource "null_resource" "dependency_blocker" {
  depends_on = ["module.aws", "aws_route53_record.ns", "aws_iam_role_policy.opsman_patch"]
}

# Use intermediate local to hold JSON encoded SSH key
locals {
  ssh_private_key_encoded = "${jsonencode(module.aws.ops_manager_ssh_private_key)}"
}

module "common" {
  source = "../common"

  env_name = "${var.env_name}"
  iaas     = "light*aws"
  region   = "${var.region}"
  azs      = ["${lookup(var.az1, var.region)}", "${lookup(var.az2, var.region)}", "${lookup(var.az3, var.region)}"]

  ssl_cert                     = "${local.cert_full_chain}"
  ssl_private_key              = "${local.cert_key}"
  opsman_user                  = "${var.opsman_user}"
  opsman_password              = "${var.opsman_password}"
  opsman_ip                    = "${module.aws.ops_manager_ip}"
  opsman_host                  = "${module.aws.ops_manager_dns}"
  opsman_ssh_key               = "${module.aws.ops_manager_ssh_private_key}"
  opsman_configuration         = "${data.template_file.om_configuration.rendered}"

  bosh_director_ip             = "${cidrhost(module.aws.management_subnet_cidrs[0], 10)}"

  pivnet_token = "${var.pivnet_token}"

  pas_product_configuration  = "${data.template_file.pas_product_configuration.rendered}"

  apps_domain = "${module.aws.apps_domain}"
  sys_domain  = "${module.aws.sys_domain}"

  ssh_elb_name      = "${join(",", formatlist("alb:%s", module.aws.ssh_target_groups))}"
  web_elb_names     = "${formatlist("alb:%s", module.aws.web_target_groups)}"
  compute_instances = "${var.compute_instance_count}"

  opsman_id = "12345"

  tiles = "${var.tiles}"

  healthwatch_mysql_instance_type     = "m5.xlarge"
  healthwatch_forwarder_instance_type = "m5.large"

  metrics_mysql_instance_type         = "m5.large"
  metrics_postgres_instance_type      = "r5.large"

  wavefront_token = "${var.wavefront_token}"

  vm_extensions = [
    "${data.template_file.om_vm_extension_web.rendered}",
    "${data.template_file.om_vm_extension_ssh.rendered}"
  ]

  dependency_blocker = "${null_resource.dependency_blocker.id}"
}

resource "null_resource" "apply_common" {
  depends_on = ["module.common"]

  provisioner "remote-exec" {
    inline = ["apply_changes"]
  }

  count = "${var.auto_apply == "1" ? 1 : 0}"

  connection {
    host        = "${module.aws.ops_manager_dns}"
    user        = "ubuntu"
    private_key = "${module.aws.ops_manager_ssh_private_key}"
  }
}
