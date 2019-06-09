data "template_file" "om_management_subnets" {
  template = "${chomp(file("${path.module}/templates/opsman_subnet_config.yml"))}"

  vars {
    id       = "${module.gcp.network_name}/${module.gcp.management_subnet_name}/${var.region}"
    dns      = "169.254.169.254"
    cidr     = "${module.gcp.management_subnet_cidrs[0]}"
    gateway  = "${module.gcp.management_subnet_gateway}"
    reserved = "${cidrhost(module.gcp.management_subnet_cidrs[0], 0) }-${cidrhost(module.gcp.management_subnet_cidrs[0], 9) }"

    az1 = "${module.gcp.azs[0]}"
    az2 = "${module.gcp.azs[1]}"
    az3 = "${module.gcp.azs[2]}"
  }
}

data "template_file" "om_pas_subnets" {
  template = "${chomp(file("${path.module}/templates/opsman_subnet_config.yml"))}"

  vars {
    id       = "${module.gcp.network_name}/${module.gcp.pas_subnet_name}/${var.region}"
    dns      = "169.254.169.254"
    cidr     = "${module.gcp.pas_subnet_cidrs[0]}"
    gateway  = "${module.gcp.pas_subnet_gateway}"
    reserved = "${cidrhost(module.gcp.pas_subnet_cidrs[0], 0) }-${cidrhost(module.gcp.pas_subnet_cidrs[0], 9) }"

    az1 = "${module.gcp.azs[0]}"
    az2 = "${module.gcp.azs[1]}"
    az3 = "${module.gcp.azs[2]}"
  }
}

data "template_file" "om_services_subnets" {
  template = "${chomp(file("${path.module}/templates/opsman_subnet_config.yml"))}"

  vars {
    id       = "${module.gcp.network_name}/${module.gcp.services_subnet_name}/${var.region}"
    dns      = "169.254.169.254"
    cidr     = "${module.gcp.services_subnet_cidrs[0]}"
    gateway  = "${module.gcp.services_subnet_gateway}"
    reserved = "${cidrhost(module.gcp.services_subnet_cidrs[0], 0) }-${cidrhost(module.gcp.services_subnet_cidrs[0], 9) }"

    az1 = "${module.gcp.azs[0]}"
    az2 = "${module.gcp.azs[1]}"
    az3 = "${module.gcp.azs[2]}"
  }
}

data "template_file" "om_configuration" {
  template = "${chomp(file("${path.module}/templates/opsman_config_ops.yml"))}"

  vars {
    az1 = "${module.gcp.azs[0]}"
    az2 = "${module.gcp.azs[1]}"
    az3 = "${module.gcp.azs[2]}"

    management_subnets = "${join("\n", data.template_file.om_management_subnets.*.rendered)}"
    pas_subnets = "${join("\n", data.template_file.om_pas_subnets.*.rendered)}"
    services_subnets = "${join("\n", data.template_file.om_services_subnets.*.rendered)}"

    project = "${var.project}"
    service_account = "${module.gcp.service_account_email}"
  }
}