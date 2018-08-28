#!/bin/bash

set -e

tf_state=$HOME/state/terraform.tfstate

export TF_VAR_tiles="[$tiles]"

TF_VAR_env_name=$env TF_VAR_dns_suffix=$dns_suffix TF_VAR_pivnet_token=$pivnet_token \
  terraform apply -input=false -state=$tf_state $CODEBUILD_SRC_DIR/terraform/aws
