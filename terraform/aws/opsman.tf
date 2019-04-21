data "template_file" "om_management_subnets" {
  template = "${chomp(file("${path.module}/templates/opsman_subnet_config.yml"))}"

  count = "3"

  vars {
    id = "${module.aws.management_subnet_ids[count.index]}"
    dns = "${cidrhost(var.vpc_cidr, 2)}"
    cidr = "${module.aws.management_subnet_cidrs[count.index]}"
    gateway = "${cidrhost(module.aws.management_subnet_cidrs[count.index], 1)}"
    reserved = "${cidrhost(module.aws.management_subnet_cidrs[count.index], 0) }-${cidrhost(module.aws.management_subnet_cidrs[count.index], 9) }"

    az = "${module.aws.management_subnet_availability_zones[count.index]}"
  }
}

data "template_file" "om_pas_subnets" {
  template = "${chomp(file("${path.module}/templates/opsman_subnet_config.yml"))}"

  count = "3"

  vars {
    id = "${module.aws.pas_subnet_ids[count.index]}"
    dns = "${cidrhost(var.vpc_cidr, 2)}"
    cidr = "${module.aws.pas_subnet_cidrs[count.index]}"
    gateway = "${cidrhost(module.aws.pas_subnet_cidrs[count.index], 1)}"
    reserved = "${cidrhost(module.aws.pas_subnet_cidrs[count.index], 0) }-${cidrhost(module.aws.pas_subnet_cidrs[count.index], 9) }"

    az = "${module.aws.management_subnet_availability_zones[count.index]}"
  }
}

data "template_file" "om_services_subnets" {
  template = "${chomp(file("${path.module}/templates/opsman_subnet_config.yml"))}"

  count = "3"

  vars {
    id = "${module.aws.services_subnet_ids[count.index]}"
    dns = "${cidrhost(var.vpc_cidr, 2)}"
    cidr = "${module.aws.services_subnet_cidrs[count.index]}"
    gateway = "${cidrhost(module.aws.services_subnet_cidrs[count.index], 1)}"
    reserved = "${cidrhost(module.aws.services_subnet_cidrs[count.index], 0) }-${cidrhost(module.aws.services_subnet_cidrs[count.index], 9) }"

    az = "${module.aws.management_subnet_availability_zones[count.index]}"
  }
}

data "template_file" "om_configuration" {
  template = "${chomp(file("${path.module}/templates/opsman_config.yml"))}"

  vars {
    az1 = "${module.aws.management_subnet_availability_zones[0]}"
    az2 = "${module.aws.management_subnet_availability_zones[1]}"
    az3 = "${module.aws.management_subnet_availability_zones[2]}"

    management_subnets = "${join("\n", data.template_file.om_management_subnets.*.rendered)}"
    pas_subnets = "${join("\n", data.template_file.om_pas_subnets.*.rendered)}"
    services_subnets = "${join("\n", data.template_file.om_services_subnets.*.rendered)}"

    access_key_id     = "${aws_iam_access_key.key.id}"
    secret_access_key = "${aws_iam_access_key.key.secret}"
    vpc_id            = "${module.aws.vpc_id}"
    security_group    = "${module.aws.vms_security_group_id}"
    key_pair_name     = "${module.aws.ops_manager_ssh_public_key_name}"
    ssh_private_key   = "${substr(local.ssh_private_key_encoded, 1, length(local.ssh_private_key_encoded)-2)}"
    region            = "${var.region}"
  }
}