data "template_file" "management_subnet" {
  template = "${chomp(file("${path.module}/templates/subnet.json"))}"

  vars {
    id = "${module.azure.network_name}/${module.azure.management_subnet_name}"
    dns = "168.63.129.16"
    cidr = "${module.azure.management_subnet_cidrs[0]}"
    gateway = "${module.azure.management_subnet_gateway}"
    reserved = "${cidrhost(module.azure.management_subnet_cidrs[0], 0) }-${cidrhost(module.azure.management_subnet_cidrs[0], 9) }"
  }
}

data "template_file" "pas_subnet" {
  template = "${chomp(file("${path.module}/templates/subnet.json"))}"

  vars {
    id = "${module.azure.network_name}/${module.azure.pas_subnet_name}"
    dns = "168.63.129.16"
    cidr = "${module.azure.pas_subnet_cidrs[0]}"
    gateway = "${module.azure.pas_subnet_gateway}"
    reserved = "${cidrhost(module.azure.pas_subnet_cidrs[0], 0) }-${cidrhost(module.azure.pas_subnet_cidrs[0], 9) }"
  }
}

data "template_file" "services_subnet" {
  template = "${chomp(file("${path.module}/templates/subnet.json"))}"

  vars {
    id = "${module.azure.network_name}/${module.azure.services_subnet_name}"
    dns = "168.63.129.16"
    cidr = "${module.azure.services_subnet_cidrs[0]}"
    gateway = "${module.azure.services_subnet_gateway}"
    reserved = "${cidrhost(module.azure.services_subnet_cidrs[0], 0) }-${cidrhost(module.azure.services_subnet_cidrs[0], 9) }"
  }
}

data "template_file" "network_configuration" {
  template = "${chomp(file("${path.module}/templates/networks.json"))}"

  vars {
    management_subnets = "${data.template_file.management_subnet.rendered}"
    pas_subnets = "${data.template_file.pas_subnet.rendered}"
    services_subnets = "${data.template_file.services_subnet.rendered}"
  }
}
