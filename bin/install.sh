#!/bin/bash

set -e

# Dependencies
sudo pip install boto3
wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip
sudo unzip terraform_0.11.7_linux_amd64.zip -d /bin && rm terraform_0.11.7_linux_amd64.zip
wget https://github.com/xenolf/lego/releases/download/v1.0.1/lego_v1.0.1_linux_amd64.tar.gz
sudo tar xvf lego_v1.0.1_linux_amd64.tar.gz -C /bin && rm lego_v1.0.1_linux_amd64.tar.gz && chmod +x /bin/lego
sudo wget -O /bin/om https://github.com/pivotal-cf/om/releases/download/0.37.0/om-linux && chmod +x /bin/om
apt-get update
apt-get install -qq -y curl jq

# Setup state directory
mkdir $HOME/state
aws s3 cp s3://$env.$region.$account.paasify-state $HOME/state --recursive

# Init Terraform
terraform init -input=false $CODEBUILD_SRC_DIR/terraform/aws
