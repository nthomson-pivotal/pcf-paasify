output "opsman_host" {
  value = "${module.aws.ops_manager_dns}"
}

output "opsman_user" {
  value = "${var.opsman_user}"
}

output "opsman_password" {
  value = "${module.common.opsman_password}"
}

output "opsman_ssh_private_key" {
  value = "${module.aws.ops_manager_ssh_private_key}"
}

output "vpc_id" {
  value = "${module.aws.vpc_id}"
}

output "apps_domain" {
  value = "${module.aws.apps_domain}"
}

output "sys_domain" {
  value = "${module.aws.sys_domain}"
}

output "cf_api_endpoint" {
  value = "api.${module.aws.sys_domain}"
}