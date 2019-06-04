#!/bin/bash

set -e

TERRAFORM_VERSION=0.11.7

# Dependencies
wget -q -O terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
sudo unzip terraform.zip -d /bin && rm terraform.zip

apt-get update
apt-get install -qq -y curl jq

# Setup state directory
mkdir $HOME/state
aws s3 cp s3://$state_bucket $HOME/state --recursive

. $CODEBUILD_SRC_DIR/codebuild/bin/cloud.sh

# Init Terraform
terraform init -input=false $CLOUD_TF_DIR
