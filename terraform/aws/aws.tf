provider "aws" {
  region = "${var.region}"

  version = "~> 1.33"
}

module "aws" {
  source = "github.com/pivotal-cf/terraforming-aws?ref=08e56ea"

  access_key         = "${aws_iam_access_key.key.id}"
  secret_key         = "${aws_iam_access_key.key.secret}"
  env_name           = "${var.env_name}"
  region             = "${var.region}"
  dns_suffix         = "${var.dns_suffix}"
  ops_manager_ami    = "${lookup(var.opsman_ami, var.region)}"
  availability_zones = ["${lookup(var.az1, var.region)}", "${lookup(var.az2, var.region)}", "${lookup(var.az3, var.region)}"]
  ssl_cert           = "${local.cert_full_chain}"
  ssl_private_key    = "${local.cert_key}"
}

resource "null_resource" "dependency_blocker" {
  depends_on = ["module.aws", "aws_route53_record.ns"]
}

locals {
  base_domain = "${var.env_name}.${var.dns_suffix}"
}

data "aws_route53_zone" "selected" {
  name = "${var.dns_suffix}."
}

resource "aws_route53_record" "ns" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "${local.base_domain}"
  type    = "NS"
  ttl     = "30"

  records = [
    "${module.aws.env_dns_zone_name_servers}",
  ]
}

# Use intermediate local to hold JSON encoded SSH key
locals {
  ssh_private_key_encoded = "${jsonencode(module.aws.ops_manager_ssh_private_key)}"
}

data "template_file" "iaas_configuration" {
  template = "${chomp(file("${path.module}/templates/iaas_configuration.json"))}"

  vars {
    access_key_id     = "${aws_iam_access_key.key.id}"
    secret_access_key = "${aws_iam_access_key.key.secret}"
    vpc_id            = "${module.aws.vpc_id}"
    security_group    = "${module.aws.vms_security_group_id}"
    key_pair_name     = "${module.aws.ops_manager_ssh_public_key_name}"
    ssh_private_key   = "${substr(local.ssh_private_key_encoded, 1, length(local.ssh_private_key_encoded)-2)}"
    region            = "${var.region}"
  }
}

data "template_file" "pas_resource_configuration" {
  template = "${chomp(file("${path.module}/templates/pas_resource_configuration.json"))}"

  vars {
    ssh_elb_name = "${module.aws.ssh_elb_name}"
    web_elb_name = "${module.aws.web_elb_name}"
  }
}

module "common" {
  source = "../common"

  env_name                     = "${var.env_name}"
  iaas                         = "aws"
  region                       = "${var.region}"
  az1                          = "${lookup(var.az1, var.region)}"
  az2                          = "${lookup(var.az2, var.region)}"
  az3                          = "${lookup(var.az3, var.region)}"
  ssl_cert                     = "${local.cert_full_chain}"
  ssl_private_key              = "${local.cert_key}"
  opsman_user                  = "${var.opsman_user}"
  opsman_ip                    = "${module.aws.ops_manager_ip}"
  opsman_host                  = "${module.aws.ops_manager_dns}"
  opsman_ssh_key               = "${module.aws.ops_manager_ssh_private_key}"
  opsman_iaas_configuration    = "${data.template_file.iaas_configuration.rendered}"
  opsman_network_configuration = "${data.template_file.network_configuration.rendered}"

  pivnet_token = "${var.pivnet_token}"

  pas_resource_configuration = "${data.template_file.pas_resource_configuration.rendered}"
  logger_endpoint_port       = "4443"

  apps_domain = "${module.aws.apps_domain}"
  sys_domain  = "${module.aws.sys_domain}"

  opsman_id = "12345"

  tiles = "${var.tiles}"

  mysql_backup_configuration = "${data.template_file.mysql_backup_configuration.rendered}"

  rabbitmq_resource_configuration = "${data.template_file.rabbitmq_resource_configuration.rendered}"

  healthwatch_resource_configuration = "${data.template_file.healthwatch_resource_configuration.rendered}"

  metrics_resource_configuration           = "${data.template_file.metrics_resource_configuration.rendered}"
  metrics_forwarder_resource_configuration = "${data.template_file.metrics_forwarder_resource_configuration.rendered}"

  prometheus_resource_configuration = "${data.template_file.prometheus_resource_configuration.rendered}"

  wavefront_token = "${var.wavefront_token}"

  dependency_blocker = "${null_resource.dependency_blocker.id}"
}

resource "null_resource" "apply_common" {
  depends_on = ["module.common"]

  provisioner "local-exec" {
    command = "om -t https://${module.aws.ops_manager_dns} -u ${var.opsman_user} -p ${module.common.opsman_password} apply-changes"
  }

  connection {
    host        = "${module.aws.ops_manager_dns}"
    user        = "ubuntu"
    private_key = "${module.aws.ops_manager_ssh_private_key}"
  }
}
