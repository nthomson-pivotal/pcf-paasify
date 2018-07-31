#!/bin/bash

set -e

TERRAFORM_VERSION=0.11.7
OM_CLI_VERSION=0.37.0

# Dependencies
sudo pip install boto3
wget -O terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
sudo unzip terraform.zip -d /bin && rm terraform.zip
sudo wget -O /bin/om https://github.com/pivotal-cf/om/releases/download/$OM_CLI_VERSION/om-linux && chmod +x /bin/om
apt-get update
apt-get install -qq -y curl jq

# Setup state directory
mkdir $HOME/state
aws s3 cp s3://$env.$region.$account.paasify-state $HOME/state --recursive

# Init Terraform
terraform init -input=false $CODEBUILD_SRC_DIR/terraform/aws
