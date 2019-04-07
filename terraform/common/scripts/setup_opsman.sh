#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Configure authentication in OpsMan
echo 'Configuring OpsMan authentication...'
om -k -t https://$OM_DOMAIN configure-authentication -u $OM_USERNAME -p $OM_PASSWORD -dp $OM_PASSWORD

echo 'Configuring OpsMan...'
om -k -t https://$OM_DOMAIN configure-director --iaas-configuration "$OM_IAAS_CONFIG"

om -k -t https://$OM_DOMAIN configure-director --director-configuration '{"ntp_servers_string": "time.google.com"}'

if [ "$IAAS" != "azure" ]; then
  om -k -t https://$OM_DOMAIN configure-director --az-configuration "$OM_AZ_CONFIG"
else
  echo "Skipping AZ configuration on Azure"
fi

om -k -t https://$OM_DOMAIN configure-director --networks-configuration "$OM_NETWORK_CONFIG"

om -k -t https://$OM_DOMAIN configure-director --network-assignment "$OM_NET_ASSIGN_CONFIG"

om -k -t https://$OM_DOMAIN apply-changes