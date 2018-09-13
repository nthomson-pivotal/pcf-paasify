#!/bin/bash

set -e

. $CODEBUILD_SRC_DIR/bin/cloud.sh

tf_state=$HOME/state/terraform.tfstate

export TF_VAR_env_name=$env 
export TF_VAR_dns_suffix=$dns_suffix 
export TF_VAR_pivnet_token=$pivnet_token
export TF_VAR_tiles="[$tiles]"
export TF_VAR_auto_apply=$auto_apply

if [ "$command" = "plan" ]; then
    terraform plan -state=$tf_state $CLOUD_TF_DIR
elif [ "$command" = "output" ]; then
    terraform output -state=$tf_state
else
    terraform apply -auto-approve -input=false -state=$tf_state $CLOUD_TF_DIR
fi