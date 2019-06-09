#!/bin/bash

set -e

source ~/.om_profile

# Configure authentication in OpsMan
echo 'Configuring OpsMan authentication...'
om configure-authentication -u $OM_USERNAME -p $OM_PASSWORD -dp $OM_PASSWORD

echo 'Configuring OpsMan...'
om configure-director -c /home/ubuntu/config/opsman-config.yml --ops-file /home/ubuntu/config/opsman-config-ops.yml

om apply-changes