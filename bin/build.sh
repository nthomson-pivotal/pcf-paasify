#!/bin/bash

set -e

tf_state=$HOME/state/terraform.tfstate

TF_VAR_env_name=$env TF_VAR_dns_suffix=$dns_suffix TF_VAR_pivnet_token=$pivnet_token \
  terraform plan -input=false \
  -state=$tf_state $CODEBUILD_SRC_DIR/terraform/aws

export OM_TARGET=https://$(terraform output -state=$tf_state opsman_host)
export OM_USER=$(terraform output -state=$tf_state opsman_user)
export OM_PASSWORD=$(terraform output -state=$tf_state opsman_password)

echo "Target is $OM_TARGET -- $OM_USER / $OM_PASSWORD"

om -t $OM_TARGET -u $OM_USER -p $OM_PASSWORD apply-changes
