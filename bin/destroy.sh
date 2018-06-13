#!/bin/bash

set -e

TF_VAR_env_name=$env TF_VAR_dns_suffix=$dns_suffix TF_VAR_pivnet_token=$pivnet_token \
 TF_VAR_ssl_cert_path=$HOME/state/lego/certificates/pcf.$env.$dns_suffix.crt \
 TF_VAR_ssl_private_key_path=$HOME/state/lego/certificates/pcf.$env.$dns_suffix.key \
 terraform destroy -input=false -auto-approve -state=$HOME/state/terraform.tfstate $CODEBUILD_SRC_DIR/terraform/aws
