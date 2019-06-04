data "template_file" "om_management_subnets" {
  template = "${chomp(file("${path.module}/templates/opsman_subnet_config.yml"))}"

  vars {
    id = "${module.azure.network_name}/${module.azure.management_subnet_name}"
    dns = "168.63.129.16"
    cidr = "${module.azure.management_subnet_cidrs[0]}"
    gateway = "${module.azure.management_subnet_gateway}"
    reserved = "${cidrhost(module.azure.management_subnet_cidrs[0], 0) }-${cidrhost(module.azure.management_subnet_cidrs[0], 9) }"
  }
}

data "template_file" "om_pas_subnets" {
  template = "${chomp(file("${path.module}/templates/opsman_subnet_config.yml"))}"

  vars {
    id = "${module.azure.network_name}/${module.azure.pas_subnet_name}"
    dns = "168.63.129.16"
    cidr = "${module.azure.pas_subnet_cidrs[0]}"
    gateway = "${module.azure.pas_subnet_gateway}"
    reserved = "${cidrhost(module.azure.pas_subnet_cidrs[0], 0) }-${cidrhost(module.azure.pas_subnet_cidrs[0], 9) }"
  }
}

data "template_file" "om_services_subnets" {
  template = "${chomp(file("${path.module}/templates/opsman_subnet_config.yml"))}"

  vars {
    id = "${module.azure.network_name}/${module.azure.services_subnet_name}"
    dns = "168.63.129.16"
    cidr = "${module.azure.services_subnet_cidrs[0]}"
    gateway = "${module.azure.services_subnet_gateway}"
    reserved = "${cidrhost(module.azure.services_subnet_cidrs[0], 0) }-${cidrhost(module.azure.services_subnet_cidrs[0], 9) }"
  }
}

data "template_file" "om_configuration" {
  template = "${chomp(file("${path.module}/templates/opsman_config.yml"))}"

  vars {
    management_subnets = "${join("\n", data.template_file.om_management_subnets.*.rendered)}"
    pas_subnets        = "${join("\n", data.template_file.om_pas_subnets.*.rendered)}"
    services_subnets   = "${join("\n", data.template_file.om_services_subnets.*.rendered)}"

    subscription_id = "${data.azurerm_client_config.current.subscription_id}"
    tenant_id       = "${data.azurerm_client_config.current.tenant_id}"
    client_id       = "${azurerm_azuread_application.paasify.application_id}"
    client_secret   = "${random_string.client_secret.result}"

    resource_group_name       = "${module.azure.pcf_resource_group_name}"
    bosh_storage_account_name = "${module.azure.bosh_root_storage_account}"
    ssh_public_key            = "${substr(local.ssh_public_key_encoded, 1, length(local.ssh_public_key_encoded)-2)}"
    ssh_private_key           = "${substr(local.ssh_private_key_encoded, 1, length(local.ssh_private_key_encoded)-2)}"
  }
}