variable "env_name" {
  type = "string"
}

variable "region" {
  type = "string"
  default = "us-west-2"
}

variable "access_key" {}

variable "secret_key" {}

variable "az1" {
  type = "map"
  default = {
    "us-west-2" = "us-west-2a"
  }
}

variable "az2" {
  type = "map"
  default = {
    "us-west-2" = "us-west-2b"
  }
}

variable "az3" {
  type = "map"
  default = {
    "us-west-2" = "us-west-2c"
  }
}

variable "opsman_ami" {
  type = "map"
  default = {
    "us-west-2" = "ami-2479e85c"
  }
}

variable "dns_suffix" {
  type = "string"
}

variable "ssl_cert_path" {
  type        = "string"
  description = "The path to an SSL certificate to be used by the LB and OpsMan"
}

variable "ssl_private_key_path" {
  type        = "string"
  description = "The path to an SSL private key to be used by the LB and OpsMan"
}

variable "opsman_user" {
  type        = "string"
  default     = "admin"
}

variable "pivnet_token" {
  type        = "string"
}

variable "compute_instance_count" {
  type        = "string"
  default = "1"
}
