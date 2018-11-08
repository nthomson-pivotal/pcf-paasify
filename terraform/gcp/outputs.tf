output "opsman_host" {
  value = "${module.gcp.ops_manager_dns}"
}

output "opsman_user" {
  value = "${var.opsman_user}"
}

output "opsman_password" {
  value = "${module.common.opsman_password}"
}

output "opsman_ssh_private_key" {
  value = "${module.gcp.ops_manager_ssh_private_key}"
}

output "apps_domain" {
  value = "${module.azure.apps_domain}"
}

output "sys_domain" {
  value = "${module.azure.sys_domain}"
}