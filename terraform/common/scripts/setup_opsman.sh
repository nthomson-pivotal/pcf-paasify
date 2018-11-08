#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Configure authentication in OpsMan
echo 'Configuring OpsMan authentication...'
om -t https://$OM_DOMAIN configure-authentication -u $OM_USERNAME -p $OM_PASSWORD -dp $OM_PASSWORD

echo 'Configuring OpsMan...'
om -t https://$OM_DOMAIN configure-bosh --iaas-configuration "$OM_IAAS_CONFIG"

om -t https://$OM_DOMAIN configure-bosh --director-configuration '{"ntp_servers_string": "time.google.com"}'

if [ "$IAAS" != "azure" ]; then
  om -t https://$OM_DOMAIN configure-bosh --az-configuration "$OM_AZ_CONFIG"
else
  echo "Skipping AZ configuration on Azure"
fi

om -t https://$OM_DOMAIN configure-bosh --networks-configuration "$OM_NETWORK_CONFIG"

om -t https://$OM_DOMAIN configure-bosh --network-assignment "$OM_NET_ASSIGN_CONFIG"

om -t https://$OM_DOMAIN apply-changes
