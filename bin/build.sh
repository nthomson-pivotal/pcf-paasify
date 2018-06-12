#!/bin/bash

set -e

tf_state=$HOME/state/terraform.tfstate

TF_VAR_env_name=$env TF_VAR_dns_suffix=$dns_suffix TF_VAR_pivnet_token=$pivnet_token TF_VAR_ssl_cert_path=$HOME/state/lego/certificates/pcf.$env.$dns_suffix.crt \
  TF_VAR_ssl_private_key_path=$HOME/state/lego/certificates/pcf.$env.$dns_suffix.key terraform apply -input=false -auto-approve \
  -state=$tfstate $CODEBUILD_SRC_DIR/terraform/aws

export OM_TARGET=https://$(terraform output -state=$tfstate opsman_host)
export OM_USER=$(terraform output -state=$tfstate opsman_user)
export OM_PASSWORD=$(terraform output -state=$tfstate opsman_password)

om apply-changes
