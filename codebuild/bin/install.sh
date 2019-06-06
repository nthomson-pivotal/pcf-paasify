#!/bin/bash

set -e

TERRAFORM_VERSION=0.11.13

# Dependencies
wget -q -O terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
sudo unzip terraform.zip -d /bin && rm terraform.zip

apt-get update
apt-get install -qq -y curl jq

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Setup state directory
mkdir $HOME/state

echo "Pulling TF state from s3://$state_bucket/$state_key"
aws s3 cp s3://$state_bucket/$state_key $HOME/state --recursive

. $CODEBUILD_SRC_DIR/codebuild/bin/cloud.sh

# Init Terraform
terraform init -input=false $CLOUD_TF_DIR
