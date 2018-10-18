variable "env_name" {
  type = "string"
}

variable "iaas" {
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
  default = "2.1.15"
}

variable "tiles" {
  type    = "list"
  default = ["mysql", "rabbit", "scs", "metrics", "healthwatch"]
}

variable "tile_versions" {
  type = "map"

  default = {
    "mysql" = "2.3.1 "
    "redis" = "1.13.4"
    "rabbit" = "1.13.8"
    "scs" = "2.0.2"
    "metrics" = "1.5.0"
    "metric-forwarder" = "1.11.3"
    "healthwatch" = "1.3.2"
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