variable "env_name" {
  type = "string"
}

variable "region" {
  type = "string"
}

variable "az1" {
  type = "string"
}

variable "az2" {
  type = "string"
}

variable "az3" {
  type = "string"
}

variable "ssl_cert" {
  type        = "string"
  description = "the contents of an SSL certificate to be used by the LB"
}

variable "ssl_private_key" {
  type        = "string"
  description = "the contents of an SSL private key to be used by the LB"
}

variable "opsman_host" {
  type        = "string"
}

variable "opsman_ssh_key" {
  type        = "string"
}

variable "opsman_user" {
  type        = "string"
}

variable "opsman_iaas_configuration" {
  type = "string"
}

variable "opsman_network_configuration" {
  type = "string"
}

variable "pivnet_token" {
  type        = "string"
}

variable "pas_resource_configuration" {
  type = "string"
}

variable "apps_domain" {
  type = "string"
}

variable "sys_domain" {
  type = "string"
}

variable "mysql_backup_configuration" {
  type = "string"
}

variable "rabbitmq_resource_configuration" {
  type = "string"
}

variable "healthwatch_resource_configuration" {
  type = "string"
}

variable "metrics_resource_configuration" {
  type = "string"
}

variable "metrics_forwarder_resource_configuration" {
  type = "string"
}
