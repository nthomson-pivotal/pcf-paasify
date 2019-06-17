data "template_file" "om_management_subnets" {
  template = "${chomp(file("${path.module}/templates/opsman_subnet_config.yml"))}"

  count = "3"

  vars {
    id       = "${module.aws.management_subnet_ids[count.index]}"
    dns      = "${cidrhost(var.vpc_cidr, 2)}"
    cidr     = "${module.aws.management_subnet_cidrs[count.index]}"
    gateway  = "${cidrhost(module.aws.management_subnet_cidrs[count.index], 1)}"
    reserved = "${cidrhost(module.aws.management_subnet_cidrs[count.index], 0) }-${cidrhost(module.aws.management_subnet_cidrs[count.index], 9) }"
    az       = "${module.aws.management_subnet_availability_zones[count.index]}"
  }
}

data "template_file" "om_pas_subnets" {
  template = "${chomp(file("${path.module}/templates/opsman_subnet_config.yml"))}"

  count = "3"

  vars {
    id       = "${module.aws.pas_subnet_ids[count.index]}"
    dns      = "${cidrhost(var.vpc_cidr, 2)}"
    cidr     = "${module.aws.pas_subnet_cidrs[count.index]}"
    gateway  = "${cidrhost(module.aws.pas_subnet_cidrs[count.index], 1)}"
    reserved = "${cidrhost(module.aws.pas_subnet_cidrs[count.index], 0) }-${cidrhost(module.aws.pas_subnet_cidrs[count.index], 9) }"
    az       = "${module.aws.management_subnet_availability_zones[count.index]}"
  }
}

data "template_file" "om_services_subnets" {
  template = "${chomp(file("${path.module}/templates/opsman_subnet_config.yml"))}"

  count = "3"

  vars {
    id       = "${module.aws.services_subnet_ids[count.index]}"
    dns      = "${cidrhost(var.vpc_cidr, 2)}"
    cidr     = "${module.aws.services_subnet_cidrs[count.index]}"
    gateway  = "${cidrhost(module.aws.services_subnet_cidrs[count.index], 1)}"
    reserved = "${cidrhost(module.aws.services_subnet_cidrs[count.index], 0) }-${cidrhost(module.aws.services_subnet_cidrs[count.index], 9) }"
    az       = "${module.aws.management_subnet_availability_zones[count.index]}"
  }
}

data "template_file" "om_configuration" {
  template = "${chomp(file("${path.module}/templates/opsman_config_ops.yml"))}"

  vars {
    az1 = "${module.aws.management_subnet_availability_zones[0]}"
    az2 = "${module.aws.management_subnet_availability_zones[1]}"
    az3 = "${module.aws.management_subnet_availability_zones[2]}"

    management_subnets = "${join("\n", data.template_file.om_management_subnets.*.rendered)}"
    pas_subnets        = "${join("\n", data.template_file.om_pas_subnets.*.rendered)}"
    services_subnets   = "${join("\n", data.template_file.om_services_subnets.*.rendered)}"

    iam_instance_profile        = "${module.aws.ops_manager_iam_instance_profile_name}"
    vpc_id                      = "${module.aws.vpc_id}"
    security_group              = "${module.aws.vms_security_group_id}"
    key_pair_name               = "${module.aws.ops_manager_ssh_public_key_name}"
    ssh_private_key             = "${substr(local.ssh_private_key_encoded, 1, length(local.ssh_private_key_encoded)-2)}"
    region                      = "${var.region}"
    bucket_name                 = "${module.aws.ops_manager_bucket}"
    bucket_access_key_id        = "${module.aws.ops_manager_iam_user_access_key}"
    bucket_secret_access_key    = "${module.aws.ops_manager_iam_user_secret_key}"
    ebs_encryption              = "${var.encrypt_ebs}"
  }
}

data "template_file" "om_vm_extension_web" {
  template = "${chomp(file("${path.module}/templates/vm_extension.yml"))}"

  vars {
    name          = "web_lb_security_groups"
    target_groups = "${join(", ", module.aws.web_target_groups)}"
    sg_name       = "web_lb_security_group"
  }
}

data "template_file" "om_vm_extension_ssh" {
  template = "${chomp(file("${path.module}/templates/vm_extension.yml"))}"

  vars {
    name          = "ssh_lb_security_groups"
    target_groups = "${join(", ", module.aws.ssh_target_groups)}"
    sg_name       = "ssh_lb_security_group"
  }
 }