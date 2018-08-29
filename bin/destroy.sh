#!/bin/bash

set -e

. $CODEBUILD_SRC_DIR/bin/cloud.sh

TF_VAR_env_name=$env TF_VAR_dns_suffix=$dns_suffix TF_VAR_pivnet_token=$pivnet_token \
 terraform destroy -input=false -auto-approve -state=$HOME/state/terraform.tfstate $CLOUD_TF_DIR
