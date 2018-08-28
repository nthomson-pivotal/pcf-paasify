#!/bin/bash

set -e

tf_state=$HOME/state/terraform.tfstate

tiles_env="'[$tiles]'"

echo $tiles_env

TF_VAR_env_name=$env TF_VAR_dns_suffix=$dns_suffix TF_VAR_pivnet_token=$pivnet_token TF_VAR_tiles=$tiles_env \
  terraform plan -input=false -state=$tf_state $CODEBUILD_SRC_DIR/terraform/aws
