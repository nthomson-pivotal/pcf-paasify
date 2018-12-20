variable "env_name" {
  type = "string"
}

variable "region" {
  type    = "string"
  default = "us-west-2"
}

variable "az1" {
  type = "map"

  default = {
    "us-west-2" = "us-west-2a"
    "us-east-1" = "us-east-1a"
  }
}

variable "az2" {
  type = "map"

  default = {
    "us-west-2" = "us-west-2b"
    "us-east-1" = "us-east-1b"
  }
}

variable "az3" {
  type = "map"

  default = {
    "us-west-2" = "us-west-2c"
    "us-east-1" = "us-east-1c"
  }
}

variable "opsman_version" {
  type    = "string"
  default = "2.4"
}

variable "opsman_build" {
  type    = "string"
  default = "117"
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