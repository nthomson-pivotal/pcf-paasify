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

variable "opsman_configuration" {
  type = "string"
  description = "YAML formatted string that contains OpsMan configuration for the director"
}

variable "bosh_director_ip" {
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
  default = "2.4.6"
}

variable "tiles" {
  type    = "list"
  default = []
}

variable "tile_versions" {
  type = "map"

  default = {
    "mysql" = "2.4.6"
    "redis" = "2.0.2"
    "rabbit" = "1.15.11"
    "scs" = "2.0.10"
    "metrics" = "1.6.0"
    "healthwatch" = "1.5.4"
  }
}

variable "healthwatch_resource_configuration" {
  type = "string"
}

variable "metrics_resource_configuration" {
  type = "string"
}

variable "logger_endpoint_port" {
  default = "443"
}

variable "dependency_blocker" {
  type = "string"
  description = "This is used to ensure various resources block appropriately"
}