variable "env_name" {
  type = "string"
}

variable "iaas" {
  type = "string"
}

variable "region" {
  type = "string"
}

variable "azs" {
  type = "list"
}

variable "ssl_cert" {
  type        = "string"
  description = "the contents of an SSL certificate to be used by the LB"
}

variable "ssl_private_key" {
  type        = "string"
  description = "the contents of an SSL private key to be used by the LB"
}

variable "opsman_id" {
  type = "string"
}

variable "opsman_ip" {
  type = "string"
}

variable "opsman_host" {
  type = "string"
}

variable "opsman_ssh_key" {
  type = "string"
}

variable "opsman_user" {
  type = "string"
}

variable "opsman_iaas_configuration" {
  type = "string"
}

variable "opsman_network_configuration" {
  type = "string"
}

variable "opsman_az_configuration" {
  type = "string"
  default = ""
}

variable "pivnet_token" {
  type = "string"
}

variable "pas_product_configuration" {
  type = "string"
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

variable "pas_version" {
  type = "string"
  default = "2.4.0"
}

variable "tiles" {
  type    = "list"
  default = ["mysql", "rabbit", "scs", "metrics", "healthwatch"]
}

variable "tile_versions" {
  type = "map"

  default = {
    "mysql" = "2.4.2"
    "redis" = "1.14.4"
    "rabbit" = "1.14.4"
    "scs" = "2.0.4"
    "metrics" = "1.5.2"
    "metrics-forwarder" = "1.11.4"
    "healthwatch" = "1.4.4"
    "wavefront" = "0.9.3"
  }
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

variable "prometheus_resource_configuration" {
  type = "string"
}

variable "logger_endpoint_port" {
  default = "443"
}

variable "wavefront_token" {
  type    = "string"
  default = ""
}

variable "dependency_blocker" {
  type = "string"
  description = "This is used to ensure various resources block appropriately"
}