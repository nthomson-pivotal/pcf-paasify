data "template_file" "management_subnets" {
  template = "${chomp(file("${path.module}/templates/subnet.json"))}"

  vars {
    id       = "${module.gcp.network_name}/${module.gcp.management_subnet_name}/${var.region}"
    dns      = "169.254.169.254"
    cidr     = "${module.gcp.management_subnet_cidrs[0]}"
    gateway  = "${module.gcp.management_subnet_gateway}"
    reserved = "${cidrhost(module.gcp.management_subnet_cidrs[0], 0) }-${cidrhost(module.gcp.management_subnet_cidrs[0], 9) }"

    azs = "\"${join("\",\"", module.gcp.azs)}\""
  }
}

data "template_file" "pas_subnets" {
  template = "${chomp(file("${path.module}/templates/subnet.json"))}"

  vars {
    id       = "${module.gcp.network_name}/${module.gcp.pas_subnet_name}/${var.region}"
    dns      = "169.254.169.254"
    cidr     = "${module.gcp.pas_subnet_cidrs[0]}"
    gateway  = "${module.gcp.pas_subnet_gateway}"
    reserved = "${cidrhost(module.gcp.pas_subnet_cidrs[0], 0) }-${cidrhost(module.gcp.pas_subnet_cidrs[0], 9) }"

    azs = "\"${join("\",\"", module.gcp.azs)}\""
  }
}

data "template_file" "services_subnets" {
  template = "${chomp(file("${path.module}/templates/subnet.json"))}"

  vars {
    id       = "${module.gcp.network_name}/${module.gcp.services_subnet_name}/${var.region}"
    dns      = "169.254.169.254"
    cidr     = "${module.gcp.services_subnet_cidrs[0]}"
    gateway  = "${module.gcp.services_subnet_gateway}"
    reserved = "${cidrhost(module.gcp.services_subnet_cidrs[0], 0) }-${cidrhost(module.gcp.services_subnet_cidrs[0], 9) }"

    azs = "\"${join("\",\"", module.gcp.azs)}\""
  }
}

data "template_file" "network_configuration" {
  template = "${chomp(file("${path.module}/templates/networks.json"))}"

  vars {
    management_subnets = "${join(",", data.template_file.management_subnets.*.rendered)}"
    pas_subnets        = "${join(",", data.template_file.pas_subnets.*.rendered)}"
    services_subnets   = "${join(",", data.template_file.services_subnets.*.rendered)}"
  }
}
