data "template_file" "management_subnets" {
  template = "${chomp(file("${path.module}/templates/subnet.json"))}"

  count = "3"

  vars {
    id = "${module.aws.management_subnet_ids[count.index]}"
    dns = "${cidrhost("10.0.0.0/16", 2)}"
    cidr = "${module.aws.management_subnet_cidrs[count.index]}"
    gateway = "${cidrhost(module.aws.management_subnet_cidrs[count.index], 1)}"
    reserved = "${cidrhost(module.aws.management_subnet_cidrs[count.index], 0) }-${cidrhost(module.aws.management_subnet_cidrs[count.index], 9) }"

    azs = "\"${module.aws.management_subnet_availability_zones[count.index]}\""
  }
}

data "template_file" "pas_subnets" {
  template = "${chomp(file("${path.module}/templates/subnet.json"))}"

  count = "3"

  vars {
    id = "${module.aws.pas_subnet_ids[count.index]}"
    dns = "${cidrhost("10.0.0.0/16", 2)}"
    cidr = "${module.aws.pas_subnet_cidrs[count.index]}"
    gateway = "${cidrhost(module.aws.pas_subnet_cidrs[count.index], 1)}"
    reserved = "${cidrhost(module.aws.pas_subnet_cidrs[count.index], 0) }-${cidrhost(module.aws.pas_subnet_cidrs[count.index], 9) }"

    azs = "\"${module.aws.pas_subnet_availability_zones[count.index]}\""
  }
}

data "template_file" "services_subnets" {
  template = "${chomp(file("${path.module}/templates/subnet.json"))}"

  count = "3"

  vars {
    id = "${module.aws.services_subnet_ids[count.index]}"
    dns = "${cidrhost("10.0.0.0/16", 2)}"
    cidr = "${module.aws.services_subnet_cidrs[count.index]}"
    gateway = "${cidrhost(module.aws.services_subnet_cidrs[count.index], 1)}"
    reserved = "${cidrhost(module.aws.services_subnet_cidrs[count.index], 0) }-${cidrhost(module.aws.services_subnet_cidrs[count.index], 9) }"

    azs = "\"${module.aws.services_subnet_availability_zones[count.index]}\""
  }
}

data "template_file" "network_configuration" {
  template = "${chomp(file("${path.module}/templates/networks.json"))}"

  vars {
    management_subnets = "${join(",", data.template_file.management_subnets.*.rendered)}"
    pas_subnets = "${join(",", data.template_file.pas_subnets.*.rendered)}"
    services_subnets = "${join(",", data.template_file.services_subnets.*.rendered)}"
  }
}
