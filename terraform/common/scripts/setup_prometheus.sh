#!/bin/bash

set -e

om -k -t https://$OM_DOMAIN stage-product -p prometheus-dev -v 0.1.0

echo 'Configuring Prometheus...'
om -t https://$OM_DOMAIN configure-product --product-name prometheus-dev -pn "$AZ_CONFIG" -pr "$RESOURCE_CONFIG"
