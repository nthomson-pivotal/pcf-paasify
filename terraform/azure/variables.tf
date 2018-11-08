variable "env_name" {
  type = "string"
}

variable "subscription_id" {}

variable "tenant_id" {}

variable "client_id" {}

variable "client_secret" {}

variable "region" {
  type    = "string"
  default = "West US"
}

variable "opsman_version" {
  type    = "string"
  default = "2.1"
}

variable "opsman_build" {
  type    = "string"
  default = "377"
}

variable "opsman_image" {
  type = "string"
  default = "https://opsmanagerwestus.blob.core.windows.net/images/ops-manager-2.1-build.377.vhd"
}

variable "dns_suffix" {
  type = "string"
}

variable "opsman_user" {
  type    = "string"
  default = "admin"
}

variable "pivnet_token" {
  type = "string"
}

variable "compute_instance_count" {
  type    = "string"
  default = "1"
}

variable "tiles" {
  type = "list"

  default = ["mysql", "rabbit", "scs", "metrics", "healthwatch"]
}

variable "wavefront_token" {
  type    = "string"
  default = ""
}

variable "auto_apply" {
  type    = "string"
  default = "1"
}

variable "vpc_cidr" {
  type    = "string"
  default = "10.0.0.0/16"
}