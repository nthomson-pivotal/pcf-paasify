output "opsman_host" {
  value = "${module.aws.ops_manager_dns}"
}

output "opsman_user" {
  value = "${var.opsman_user}"
}

output "opsman_password" {
  value = "${module.common.opsman_password}"
}

output "vpc_id" {
  value = "${module.aws.vpc_id}"
}