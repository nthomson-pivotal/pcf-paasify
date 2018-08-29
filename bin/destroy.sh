#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

. $DIR/cloud.sh

TF_VAR_env_name=$env TF_VAR_dns_suffix=$dns_suffix TF_VAR_pivnet_token=$pivnet_token \
 terraform destroy -input=false -auto-approve -state=$HOME/state/terraform.tfstate $CLOUD_TF_DIR
