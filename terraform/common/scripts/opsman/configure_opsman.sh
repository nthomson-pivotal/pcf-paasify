#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source ~/.om_profile

# Configure authentication in OpsMan
echo 'Configuring OpsMan authentication...'
om configure-authentication -u $OM_USERNAME -p $OM_PASSWORD -dp $OM_PASSWORD

echo 'Configuring OpsMan...'
om configure-director -c /home/ubuntu/config/opsman-config.yml

om apply-changes