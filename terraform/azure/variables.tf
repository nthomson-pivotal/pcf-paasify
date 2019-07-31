variable "env_name" {
  type = "string"
}

variable "region" {
  type    = "string"
  default = "West US 2"
}

variable "vpc_cidr" {
  type        = "string"
  description = "Azure VNet CIDR (named to be consistent with other modules)"
  default     = "10.0.0.0/16"
}

variable "client_id" {}

variable "client_secret" {}

variable "tenant_id" {}

variable "subscription_id" {}

variable "dns_suffix" {
  type = "string"
}

variable "opsman_user" {
  type    = "string"
  default = "admin"
}

variable "opsman_password" {
  type = "string"
  default = ""
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

  default = []
}

variable "wavefront_token" {
  type    = "string"
  default = ""
}

variable "auto_apply" {
  type    = "string"
  default = "1"
}