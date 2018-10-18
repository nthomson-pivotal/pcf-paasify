#!/bin/bash

####################################
##
## This bash script is run on the OpsManager node itself to setup dependencies
##
####################################

set -e

PIVNET_CLI_VERSION=0.0.52
OM_VERSION=0.34.0

pivnet_api_token=$1

sudo apt-get -qq update
sudo apt-get -qq install -y jq

# Install pivnet CLI
echo 'Downloading pivnet CLI...'

wget -q https://github.com/pivotal-cf/pivnet-cli/releases/download/v$PIVNET_CLI_VERSION/pivnet-linux-amd64-$PIVNET_CLI_VERSION -O pivnet

sudo mv pivnet /usr/bin
sudo chmod +x /usr/bin/pivnet

echo 'Installed pivnet CLI'

# Install om CLI
echo 'Downloading om CLI...'

wget -q https://github.com/pivotal-cf/om/releases/download/$OM_VERSION/om-linux -O om

sudo mv om /usr/bin
sudo chmod +x /usr/bin/om

echo 'Installed om CLI'

# Login to pivnet
echo 'Logging in to pivnet...'
pivnet login --api-token $pivnet_api_token

# Convenience scripts
if [ ! -f /usr/bin/install_tile ]; then
  sudo mv /tmp/install_tile.sh /usr/bin/install_tile
fi

sudo chmod +x /usr/bin/install_tile

if [ ! -f /usr/bin/install_stemcell ]; then
  sudo mv /tmp/install_stemcell.sh /usr/bin/install_stemcell
fi

sudo chmod +x /usr/bin/install_stemcell

# Update HTTPS certificate
if [ -f /tmp/tempest.key ]; then
  sudo cp /tmp/tempest.* /var/tempest/cert

  sudo service nginx restart
fi

# TODO: Replace with reliable wait, not even sure what could fail. DNS? OpsMan restart?
sleep 30
