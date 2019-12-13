variable "env_name" {
  type = "string"
}

variable "region" {
  type    = "string"
  default = "us-west-2"
}


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

variable "vpc_cidr" {
  type    = "string"
  default = "10.0.0.0/16"
}

variable "encrypt_ebs" {
  type    = "string"
  description = "Enable encryption of EBS volumes created by BOSH"
  default = "1"
}

variable "encrypt_pas_buckets" {
  type    = "string"
  description = "Enable encryption of S3 buckets used to store PAS objects"
  default = "1"
}
